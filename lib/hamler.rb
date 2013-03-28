require "hamler/version"
require 'thor'
require 'pathname'
require 'optparse'

def available? gemname
  require gemname
rescue LoadError
  false
else
  true
end

module Hamler
  class Hamler < ::Thor
    include ::Thor::Actions
    source_root File.dirname( __FILE__ )
    no_tasks do

      @@template = File.join( File.dirname( __FILE__ ), "template.erb" )

      def source_root
        options[:input_folder]
      end

      def output_folder
        if not @output_folder
          @output_folder = Pathname.new options[:output_folder]
        end
        @output_folder
      end

      def compile file, new_name
        source = file.binread
        @in_template =
          case file.extname.downcase
          when ".haml"
            ::Haml::Engine.new( source ).render
          when '.sass'
            ::Sass::Engine.new( source, :syntax => :sass, :quiet => true).render
          when '.scss'
            ::Sass::Engine.new( source, :syntax => :scss, :quiet => true).render
          when '.coffee'
            ::CoffeeScript.compile source
          else
            source
          end
        template @@template, new_name
      end

      def input_folder
        @input_folder ||= Pathname.new options[:input_folder]
      end

      def output_folder
        @output_folder ||= Pathname.new( options[:output_folder] || options[:input_folder] )
      end

      def handle file
        new_file = new_name file
        return unless new_file
        if options[ :dry_run ] and options[ :purge ]
          say_status :would_remove, new_file
        elsif options[ :purge ]
          remove_file new_file
        elsif options[ :dry_run ]
          say_status "would compile", file
          say_status "and create", new_file
        else
          say_status :compile, file
          compile file, new_file
        end
      end

      def new_name old_name
        output_folder + old_name.relative_path_from( input_folder ).sub_ext( new_ext old_name )
      rescue
        nil
      end

      def new_ext old_name
        case old_name.extname
        when '.sass', '.scss'
          '.css'
        when '.haml'
          '.html'
        when '.coffee'
          '.js'
        else
          old_name.extname
        end
      end

      def root_task
        Pathname.new( source_root ).find \
          {|f| handle f if f.file? }
      end

    end
  end

  def self.with( argv )
    options = {
      :haml_available => available?("haml"),
      :sass_available => available?("sass"),
      :coffeescript_available \
                      => available?("coffee-script"),
      :output_folder  => false,
      :input_folder   => false,
      :dry_run        => false,
      :purge          => false,
    }
    o = OptionParser.new do |opts|
      opts.banner = "Usage: hamler [options]"
      opts.separator ''
      opts.separator 'options:'

      opts.on('-i FOLDER',
              '--input-folder FOLDER',
              'folder of source files, MUST be given') \
        {|val| options[ :input_folder ] = val }

      opts.on('-o', '--output-folder FOLDER', 'folder for output files, default to be the same with input-folder') \
        {|val| options[ :output_folder ] = val }
      opts.on('-d', '--dry-run', 'dry run without actually modify files') \
        {|val| options[ :dry_run ] = val }

      opts.on('-p', '--purge', 'purge filenames that would be generated') \
        {|val| options[ :purge ] = val }

      opts.on_tail('-h', '--help', 'show this usage') {puts opts}
    end
    o.parse( argv )

    if options[ :input_folder ]
      Hamler.new([],options).root_task
    else
      puts o
    end
  end

end
