# Hamler

one-line haml/s[ac]ss/coffeescript compiler

simply compiles each haml/s[ac]ss/coffeescript files, and output coresponding html/css/js files in place, or to another directory.

I would recommend `nanoc` for a more functional (non-1-on-1-assocation of files, layouts, etc) content compiler.

## Installation

$ gem install hamler

## Usage

`hamler` without option prints

    -i, --input-folder FOLDER        folder of source files, MUST be given
    -o, --output-folder FOLDER       folder for output files, default to be the same with input-folder
    -d, --dry-run                    dry run without actually modify or delete files
    -p, --purge                      purge filenames that would be generated
    -h, --help                       show this usage

invoke with `-i` and `-o` gives

    $ hamler -i test -o /tmp
    compile  test/a.sass
     create  /tmp/a.css
    compile  test/a_haml_file.haml
     create  /tmp/a_haml_file.html
    compile  test/subdir1/a_haml_file.haml
     create  /tmp/subdir1/a_haml_file.html
    compile  test/subdir2/b.sass
     create  /tmp/subdir2/b.css
    compile  test/subdir2/c.coffee
     create  /tmp/subdir2/c.js

`-p` purge those files. empty folders remains

    $ hamler -i test -o /tmp -p
    remove  /tmp/a.css
    remove  /tmp/a_haml_file.html
    ...

`-p -d` do not really purge those files

    $ hamler -i test -o /tmp -p -d 
    would_remove  /tmp/a.css
    would_remove  /tmp/a_haml_file.html
    ...

## Contributing

    1. Fork it
    2. Create your feature branch (`git checkout -b my-new-feature`)
    3. Commit your changes (`git commit -am 'Add some feature'`)
    4. Push to the branch (`git push origin my-new-feature`)
    5. Create new Pull Request

## License

    do-whatever-you-want-but-i-am-not-responsible-for-consequences 1.0
