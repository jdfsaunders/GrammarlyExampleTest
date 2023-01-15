module Page
    class ChromeExtensionManager < BasePage
        @@extension_ids = {grammarly: 'kbfnbcaeplbcioakkpcpgfkobkghlhen'}

        def navigate
            super 'chrome://extensions/'
        end

        def extension_installed?(extension)
            id = extension_id(extension)
            # raise ArgumentError, "Unknown Extension: #{extension.inspect}" unless  @@extension_ids.include? extension
            # extension_id = @@extension_ids[extension]
            extension_list.find_elements(:id, id).length == 1
        end

        def extension_list 
            @driver.find_element(:tag_name, 'extensions-manager').shadow_root
                .find_element(:css, '#items-list').shadow_root
        end

        def extension(id)
            extension_list.find_element(:id, id).shadow_root
        end

        def extension_enabled?(extension)
            id = extension_id(extension)
            extension(id).find_element(:id, 'enableToggle').attribute('checked') 
        end

        private

        def extension_id(extension)
            raise ArgumentError, "Unknown Extension: #{extension.inspect}" unless  @@extension_ids.include? extension
            @@extension_ids[extension]
        end
    end
end