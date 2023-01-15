Grammarly Testing Example

The tests in the script are:
- The Plugin has been installed and Enabled
- When a correction that requires Premium is detected, the user is presented a button that will bring them to the Plans page so they can upgrade
- When a word in another language is used, Grammarly may either ignore it completely or notify the user that it is an unknown word

It was developed using Ubuntu 22.04 LTWS in WSL2, so it should run in Linux and hopefully MacOs.

Setup for Ruby:
- Install ruby 3.0.2: Refer to your package manager's documentation
- Install bundler: `gem install bundler`
- run `bundle install`

Before Running the tests:
- Install Chrome
- Install the Grammarly Chrome Extension on the Default profile
- Sign into the Grammarly Extension with a Free account
- Set the language to US English
- Ensure the plugin is enabled
- Update the `google_chrome_data_dir` variable in `grammarly_test.rb` with the location of Chrome's data for your current account

Running the tests:
`rspec grammarly_test.rb`