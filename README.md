Grammarly Testing Example

This was developed using Ubuntu 22.04 LTWS in WSL2, so it should run in a normal Unbuntu (or other) Linux install and hopefully MacOs.

Selenium is being used for these tests, with rspec as the test runner and expectations library. Page elements and interacts were pulled out into Page Objects.

The tests in the script are:
- The Plugin has been installed and Enabled
- When a correction that requires Premium is detected, the user is presented a button that will bring them to the Plans page so they can upgrade
- When a word in another language is used, Grammarly may either ignore it completely or notify the user that it is an unknown word

Setup for Ruby:
- Install ruby 3.0.0, I would suggest using rvm https://rvm.io/rvm/install (there are specific instructions for Ubuntu) https://github.com/rvm/ubuntu_rvm Otherwise, refer to your package manager's documentation
    - With rvm on Ubuntu 22.04 LTS, I was having issues installing ruby 3.0.x, binaries are currently available for 3.1.1, `rvm install ruby-3.1.1` 
- when in the project directory, run `bundle install`

Before Running the tests:
- Install Chrome
- Install the Grammarly Chrome Extension on the Default profile
- Sign into the Grammarly Extension with a Free account
- Set the language to US English
- Ensure the plugin is enabled
- Update the `google_chrome_data_dir` variable in `grammarly_test.rb` with the location of Chrome's data for your current account

Running the tests:
`rspec grammarly_test.rb --format documentation`