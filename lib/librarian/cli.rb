require 'thor'
require 'thor/actions'
require 'librarian'

module Librarian
  class Cli < Thor

    include Thor::Actions
    include Particularity
    extend Particularity

    class << self
      def bin!
        begin
          start
        rescue Librarian::Error => e
          root_module.ui.error e.message
          root_module.ui.debug e.backtrace.join("\n")
          exit (e.respond_to?(:status_code) ? e.status_code : 1)
        rescue Interrupt => e
          root_module.ui.error "\nQuitting..."
          root_module.ui.debug e.backtrace.join("\n")
          exit 1
        end
      end
    end

    def initialize(*)
      super
      the_shell = (options["no-color"] ? Thor::Shell::Basic.new : shell)
      root_module.ui = UI::Shell.new(the_shell)
      root_module.ui.debug! if options["verbose"]
    end

    desc "clean", "Cleans out the cache and install paths."
    method_option "verbose"
    def clean
      root_module.ensure!
      root_module.clean!
    end

    desc "install", "Installs all of the cookbooks you specify."
    method_option "verbose"
    def install
      root_module.ensure!
      root_module.install!
    end

  end
end
