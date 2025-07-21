module Fastlane
  module Actions
    class TeamsxAction < Action
      def self.run(params)
        require 'net/http'
        require 'uri'

        # Handle parameter fallbacks for backward compatibility
        main_title = params[:main_title] || params[:title]
        body_text = params[:body] || params[:message]
        subtitle = params[:subtitle]

        # Build mentions text and entities
        mentions = params[:mentions] || []
        mentions_text = mentions.map { |m| "<at>#{m['at_text']}</at>" }.join(', ')
        entities = mentions.map do |m|
          {
            "type" => "mention",
            "text" => "<at>#{m['at_text']}</at>",
            "mentioned" => {
              "id" => m['id'],
              "name" => m['name']
            }
          }
        end

        # Build facts
        facts = (params[:facts] || []).map do |fact|
          {
            "title" => fact["title"],
            "value" => fact["value"]
          }
        end

        # Build Adaptive Card body blocks with all sections optional
        body_blocks = []
        if main_title && !main_title.strip.empty?
          body_blocks << {
            "type" => "TextBlock",
            "text" => main_title,
            "id" => "Title",
            "spacing" => "Medium",
            "horizontalAlignment" => "Center",
            "size" => "ExtraLarge",
            "weight" => "Bolder",
            "color" => "Accent"
          }
        end
        if subtitle && !subtitle.strip.empty?
          body_blocks << {
            "type" => "TextBlock",
            "size" => "Medium",
            "weight" => "Bolder",
            "text" => subtitle
          }
        end
        if body_text && !body_text.strip.empty?
          body_blocks << { "type" => "TextBlock", "text" => body_text }
        end
        if !mentions_text.strip.empty?
          body_blocks << { "type" => "TextBlock", "text" => "Mentions: #{mentions_text}" }
        end
        if facts && !facts.empty?
          body_blocks << {
            "type" => "FactSet",
            "facts" => facts,
            "id" => "acFactSet"
          }
        end

        payload = {
          "type" => "message",
          "attachments" => [
            {
              "contentType" => "application/vnd.microsoft.card.adaptive",
              "content" => {
                "type" => "AdaptiveCard",
                "body" => body_blocks,
                "$schema" => "http://adaptivecards.io/schemas/adaptive-card.json",
                "version" => "1.0",
                "msteams" => {
                  "width" => "full",
                  "entities" => entities
                }
              }
            }
          ]
        }

        json_headers = { 'Content-Type' => 'application/json' }
        uri = URI.parse(params[:teams_url])
        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = true
        response = http.post(uri.path, payload.to_json, json_headers)

        check_response_code(response)
      end

      def self.check_response_code(response)
        if response.code.to_i == 200 && response.body.to_i == 1
          true
        else
          UI.user_error!("An error occurred: #{response.body}")
        end
      end

      def self.description
        "Send a message to your Microsoft Teams channel via the webhook connector"
      end

      def self.authors
        ["Ankun"]
      end

      def self.details
        "Send a message to your Microsoft Teams channel"
      end

      def self.available_options
        [
          FastlaneCore::ConfigItem.new(key: :title,
                                       env_name: "FL_TEAMS_TITLE",
                                       description: "The title that should be displayed on Teams"),
          FastlaneCore::ConfigItem.new(key: :message,
                                       env_name: "FL_TEAMS_MESSAGE",
                                       description: "The message that should be displayed on Teams. This supports the standard Teams markup language"),
          FastlaneCore::ConfigItem.new(key: :main_title,
                                       env_name: "FL_TEAMS_MAIN_TITLE",
                                       description: "The main title that should be displayed on Teams (preferred over :title if both are provided)",
                                       optional: true),
          FastlaneCore::ConfigItem.new(key: :body,
                                       env_name: "FL_TEAMS_BODY",
                                       description: "The main body text of the message (preferred over :message if both are provided)",
                                       optional: true),
          FastlaneCore::ConfigItem.new(key: :subtitle,
                                       env_name: "FL_TEAMS_SUBTITLE",
                                       description: "An optional subtitle for the Teams message",
                                       optional: true),
          FastlaneCore::ConfigItem.new(key: :mentions,
                                       env_name: "FL_TEAMS_MENTIONS",
                                       description: "Array of mentions to include in the message (each should be a hash with 'at_text', 'id', and 'name')",
                                       type: Array,
                                       optional: true),
          FastlaneCore::ConfigItem.new(key: :facts,
                                       type: Array,
                                       env_name: "FL_TEAMS_FACTS",
                                       description: "Optional facts"),
          FastlaneCore::ConfigItem.new(key: :teams_url,
                                       env_name: "FL_TEAMS_URL",
                                       sensitive: true,
                                       description: "Create an Incoming WebHook for your Teams channel",
                                       verify_block: proc do |value|
                                         UI.user_error!("Invalid URL, must start with https://") unless value.start_with? "https://"
                                       end),
          FastlaneCore::ConfigItem.new(key: :theme_color,
                                       env_name: "FL_TEAMS_THEME_COLOR",
                                       description: "Theme color of the message card",
                                       default_value: "0078D7")
        ]
      end

      def self.example_code
        [
          'teams(
            title: "Fastlane says hello",
            message: "App successfully released!",
            facts:[
              {
                "name"=>"Platform",
                "value"=>"Android
              },
              {
                "name"=>"Lane",
                "value"=>"android internal"
              }
            ],
            teams_url: "https://outlook.office.com/webhook/..."
          )'
        ]
      end

      def self.category
        :notifications
      end

      def self.is_supported?(platform)
        true
      end
    end
  end
end
