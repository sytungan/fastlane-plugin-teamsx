# teamsx plugin

[![fastlane Plugin Badge](https://rawcdn.githack.com/fastlane/fastlane/master/fastlane/assets/plugin-badge.svg)](https://rubygems.org/gems/fastlane-plugin-teamsx)

## Getting Started

This project is a [_fastlane_](https://github.com/fastlane/fastlane) plugin. To get started with `fastlane-plugin-teamsx`, add it to your project by running:

```bash
fastlane add_plugin teamsx
```

## About teamsx

Deliver message to MSTeams

**Note to author:** Add a more detailed description about this plugin here. If your plugin contains multiple actions, make sure to mention them here.

## Example

Check out the [example `Fastfile`](fastlane/Fastfile) to see how to use this plugin. Try it by cloning the repo, running `fastlane install_plugins` and `bundle exec fastlane test`.

**Note to author:** Please set up a sample project to make it easy for users to explore what your plugin does. Provide everything that is necessary to try out the plugin in this project (including a sample Xcode/Android project if necessary)

## Run tests for this plugin

To run both the tests, and code style validation, run

```
rake
```

To automatically fix many of the styling issues, use
```
rubocop -a
```

## Issues and Feedback

For any other issues and feedback about this plugin, please submit it to this repository.

## Troubleshooting

If you have trouble using plugins, check out the [Plugins Troubleshooting](https://docs.fastlane.tools/plugins/plugins-troubleshooting/) guide.

## Using _fastlane_ Plugins

For more information about how the `fastlane` plugin system works, check out the [Plugins documentation](https://docs.fastlane.tools/plugins/create-plugin/).

## About _fastlane_

_fastlane_ is the easiest way to automate beta deployments and releases for your iOS and Android apps. To learn more, check out [fastlane.tools](https://fastlane.tools).

## Sample Usage

Add the following lane to your `Fastfile` to use the TeamsX action:

```ruby
lane :notify_teams do
  teamsx(
    # Required parameters
    title: "Release Notification",           # Used as fallback for main_title
    message: "A new version has been released!", # Used as fallback for body
    teams_url: "https://outlook.office.com/webhook/your-webhook-url",

    # Optional parameters for Adaptive Card
    main_title: "🚀 New Release!",           # Large header (optional)
    subtitle: "Production Deployment",       # Subtitle (optional)
    body: "Version 1.2.3 is now live.",     # Main body text (optional)
    mentions: [                              # Optional mentions (array of hashes)
      { "id" => "user-id-1", "name" => "Alice", "at_text" => "Alice" },
      { "id" => "user-id-2", "name" => "Bob", "at_text" => "Bob" }
    ],
    facts: [                                 # Optional facts (array of hashes)
      { "title" => "Environment", "value" => "Production" },
      { "title" => "Version", "value" => "1.2.3" }
    ]
  )
end
```

- Only `title`, `message`, and `teams_url` are required.
- All other parameters are optional and will be included in the Teams message if provided.
- If `main_title` or `body` are not provided, the action will use `title` and `message` as fallbacks.
- You can omit any section (subtitle, mentions, facts) and it will not appear in the card.
