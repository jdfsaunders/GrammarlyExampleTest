require 'selenium-webdriver'
require 'rspec'


describe 'GrammarlyExtension' do
    
    let(:wait) { Selenium::WebDriver::Wait.new(:timeout => 20) }

    let(:driver) do
        options = Selenium::WebDriver::Chrome::Options.new
        options.add_argument('user-data-dir=/home/jesse/.config/google-chrome')
        driver = Selenium::WebDriver.for(:chrome, capabilities: options)
        # I prefer disabling implicit waits and making waits explicit
        driver.manage.timeouts.implicit_wait = 0
        driver
    end

    # Test Page
    def navigate_to_test_page
        url = 'https://tarry-sturdy-indigo.glitch.me/'
        driver.navigate.to url
    end

    def text_area 
        driver.find_element(:id, 'testingTextArea')
    end
    
    def enter_text(input)
        text_area.send_keys input
        sleep(1) # some time for typing to be picked up
    end

    # Grammarly Page Stuff
    def grammarly_extension_elements
        driver.find_elements(:tag_name, 'grammarly-extension')
    end

    def grammarly_highlights
        grammarly_extension_elements.last.shadow_root.find_elements(:css, '[data-grammarly-part="highlight"]')
    end

    def grammarly_button 
        grammarly_extension_elements.first.shadow_root.find_element(:css, '[data-grammarly-part="gbutton"]')
    end

    def grammarly_mirror_element
        driver.find_element(:tag_name, 'grammarly-mirror')
    end

    def unknown_word_card_header 
        grammarly_mirror_element.shadow_root.find_element(:css, '[data-grammarly-part="unknown-word-card"] [data-grammarly-part="card-header"]')
    end

    def upgrade_button 
        grammarly_mirror_element.shadow_root.find_element(:css, '[data-name="goPremiumExp"]')
    end

    def wait_until_grammarly_idle
        wait.until { grammarly_button.attribute('data-gbutton-checking-status') == 'idle'}
    end

    # Chrome Extension Management
    let(:extension_url) { 'chrome://extensions/' }
    def extension_item_list 
        driver.find_element(:tag_name, 'extensions-manager').shadow_root
            .find_element(:css, '#items-list').shadow_root
    end
    def extension_item(extension_id)
        extension_item_list.find_element(:id, extension_id).shadow_root
    end

    def extension_installed?(extension_id)
        extension_item_list.find_elements(:id, extension_id).length == 1
    end

    def extension_item_enabled?(extension_id)
        extension_item(extension_id).find_element(:id, 'enableToggle').attribute('checked') 
    end

    let(:grammarly_id) { 'kbfnbcaeplbcioakkpcpgfkobkghlhen' }

    # this will stay as a general helper method here
    def wait_for_grammarly_extension_ready
        text_area.click
        wait.until { grammarly_extension_elements.length > 0 }
    end

    after do
        driver.quit
    end

    it 'is installed and enabled' do
        # Validate Grammarly is installed and enabled
        driver.navigate.to extension_url
        expect(extension_installed?(grammarly_id)).to be_truthy, "The Grammarly plugin either is not installed or the extension id has changed"
        expect(extension_item_enabled?(grammarly_id)).to be_truthy, "The grammarly plugin is not enabled, enable it in the test profile and re-run tests"
    end

    it 'gives the user a button that allows the user to subscribe if premium feature correction is detected' do
        navigate_to_test_page
        wait_for_grammarly_extension_ready
        enter_text 'that was a mistake I makes'
        
        wait_until_grammarly_idle
        grammarly_button.click

        wait.until { upgrade_button }
        wait.until { upgrade_button.displayed? }
        expect(upgrade_button.text).to eq 'Unlock Premium'
        upgrade_button.click

        wait.until { driver.window_handles.length == 2}

        driver.switch_to.window(driver.window_handles.last)
        expect(driver.current_url).to start_with 'https://www.grammarly.com/plans?alerts='
    end

    it 'does not handle Labrador Inuttitut well' do
        navigate_to_test_page
        wait_for_grammarly_extension_ready
        enter_text "Let's put the baby in the kailluaKattautik and go for a walk today.  But the plugin will say kailluakattautik is misspelled."
        wait_until_grammarly_idle

        expect(grammarly_button.text).to eq '1'
        driver.action.move_to(grammarly_highlights.first).perform
        expect(unknown_word_card_header.text).to end_with 'kailluakattautik'
    end

end
