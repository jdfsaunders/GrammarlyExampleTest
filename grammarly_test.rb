require 'selenium-webdriver'
require 'rspec'
require 'require_all'
require_all 'page/'
describe 'GrammarlyExtension' do

    let(:google_chrome_data_dir) { '/home/jesse/.config/google-chrome' }
    
    let(:wait) { Selenium::WebDriver::Wait.new(:timeout => 20) }

    let(:driver) do
        options = Selenium::WebDriver::Chrome::Options.new
        options.add_argument("user-data-dir=#{google_chrome_data_dir}")
        options.add_argument('start-maximized')
        driver = Selenium::WebDriver.for(:chrome, capabilities: options)
        # I prefer disabling implicit waits and making waits explicit
        driver.manage.timeouts.implicit_wait = 0
        driver
    end

    let(:grammarly) do
        Page::Grammarly.new(driver, wait)
    end

    let(:chrome_extension_manager) do
        Page::ChromeExtensionManager.new(driver, wait)
    end

    let(:test_page) do
        Page::TestPage.new(driver, wait)
    end

    # Grammarly doesn't seem to recognize this text area until it has been clicked into
    def wait_for_grammarly_extension_ready
        test_page.text_area.click
        wait.until { grammarly.extension_containers.length > 0 }
    end

    after do
        driver.quit
    end

    it 'is installed and enabled' do
        # Validate Grammarly is installed and enabled
        chrome_extension_manager.navigate
        expect(chrome_extension_manager.extension_installed?(:grammarly)).to be_truthy, "The Grammarly plugin either is not installed or the extension id has changed"
        expect(chrome_extension_manager.extension_enabled?(:grammarly)).to be_truthy, "The grammarly plugin is not enabled, enable it in the test profile and re-run tests"
    end

    it 'gives the user a button that allows the user to subscribe if premium feature correction is detected' do
        test_page.navigate
        wait_for_grammarly_extension_ready
        test_page.text_area.send_keys 'that was a mistake I makes'
        
        grammarly.wait_until_idle
        grammarly.status_indicator.click

        wait.until { grammarly.upgrade_button }
        wait.until { grammarly.upgrade_button.displayed? }
        expect(grammarly.upgrade_button.text).to eq 'Unlock Premium'
        grammarly.upgrade_button.click

        wait.until { driver.window_handles.length == 2}

        driver.switch_to.window(driver.window_handles.last)
        expect(driver.current_url).to start_with 'https://www.grammarly.com/plans?alerts='
    end

    it 'does not handle Labrador Inuttitut well' do
        test_page.navigate
        wait_for_grammarly_extension_ready
        test_page.text_area.send_keys "Let's put the baby in the kailluaKattautik and go for a walk today.  But the plugin will say kailluakattautik is misspelled."
        grammarly.wait_until_idle

        expect(grammarly.status_indicator.text).to eq '1'
        driver.action.move_to(grammarly.highlights.first).perform
        expect(grammarly.unknown_word_card_header.text).to end_with 'kailluakattautik'
    end

end
