module Page
    class Grammarly < BasePage
        # This shouldn't be inheriting from page, since it doesn't have a navigate method

        def extension_containers
            @driver.find_elements(:tag_name, 'grammarly-extension')
        end

        def highlights
            extension_containers.last.shadow_root.find_elements(:css, '[data-grammarly-part="highlight"]')
        end

        def status_indicator
            extension_containers.first.shadow_root.find_element(:css, '[data-grammarly-part="gbutton"]')
        end

        def mirrored_content_container
            @driver.find_element(:tag_name, 'grammarly-mirror')
        end

        def unknown_word_card_header 
            mirrored_content_container.shadow_root.find_element(:css, '[data-grammarly-part="unknown-word-card"] [data-grammarly-part="card-header"]')
        end

        def upgrade_button 
            mirrored_content_container.shadow_root.find_element(:css, '[data-name="goPremiumExp"]')
        end

        def wait_until_idle
            statusAttribute = 'data-gbutton-checking-status'
            # We should give some time for the grammarly plugin time to start working in case this is called immediately after typing
            sleep(1) if status_indicator.attribute(statusAttribute) == 'idle'
            @wait.until { status_indicator.attribute(statusAttribute) == 'idle'}
        end

    end
end
