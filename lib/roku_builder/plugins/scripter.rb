# ********** Copyright Viacom, Inc. Apache 2.0 **********

module RokuBuilder

  # Helper for extending for scripting
  class Scripter
    extend Plugin

    def self.commands
      {print: {source: true}}
    end

    def self.parse_options(option_parser:, options:)
      option_parser.seperator("Commands for Scripter Plugin:")
       option_parser.on("--print ATTRIBUTE", "Print attribute for scripting") do |a|
         byebug
         options[:print] = a.to_sym
       end
    end

    def initialize(config:)
      @config = config
    end

    def print(config:, options:)
      attributes = [
        :title, :build_version, :app_version, :root_dir, :app_name
      ]

      unless attributes.include? options[:print]
        raise ExecutionError, "Unknown attribute: #{options[:print]}"
      end

      manifest = Manifest.new(config: config)

      case options[:print]
      when :root_dir
        printf "%s", config.project[:directory]
      when :app_name
        printf "%s", config.project[:app_name]
      when :title
        printf "%s", manifest.title
      when :build_version
        printf "%s", manifest.build_version
      when :app_version
        major = manifest.major_version
        minor = manifest.minor_version
        printf "%s.%s", major, minor
      end
    end
  end

  RokuBuilder.register_plugin(klass: Scripter, name: "scripter")
end
