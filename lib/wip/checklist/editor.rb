require 'irb'
require 'fileutils'
require 'tempfile'
require 'shellwords'
require 'yaml'

module WIP
  module Checklist
    class Editor
      # VERSION = '0.0.10'
      EDITORS = Hash.new { |h,k| h[k] = Editor.new(k) }

      def self.edit(editor, filepath)
        find_editor[editor].edit(filepath)
      end

      def self.find_editor
        # maybe serialise last file to disk, for recovery
        if defined?(Pry) and IRB == Pry
          IRB.config.interactive_editors ||= EDITORS
        else
          IRB.conf[:interactive_editors] ||= EDITORS
        end
      end

      attr_accessor :editor

      def initialize(editor)
        @editor = editor.to_s
      end

      def edit(filepath)
        file = begin
          FileUtils.touch(filepath) unless File.exist?(filepath)
          File.new(filepath)
        end

        mtime = File.stat(filepath).mtime
        args  = Shellwords.shellwords(@editor)
        args << filepath

        file.close rescue nil
        system(*args)
      end

      module Editors
        {
          :vi    => nil,
          :vim   => nil,
          :emacs => nil,
          :nano  => nil,
          :mate  => 'mate -w',
          :mvim  => 'mvim -g -f' + case ENV['TERM_PROGRAM']
            when 'iTerm.app';      ' -c "au VimLeave * !open -a iTerm"'
            when 'Apple_Terminal'; ' -c "au VimLeave * !open -a Terminal"'
            else '' #don't do tricky things if we don't know the Term
          end
        }.each do |k,v|
          define_method(k) do |*args|
            InteractiveEditor.edit(v || k, self, *args)
          end
        end

        def edit(filepath)
          if ENV['EDITOR'].to_s.size > 0
            Editor.edit(ENV['EDITOR'], filepath)
          else
            raise "You need to set the EDITOR environment variable first"
          end
        end
      end
    end
  end
end
