module Page
    class TestPage < BasePage
        def navigate
            super 'https://tarry-sturdy-indigo.glitch.me/'
        end
    
        def text_area 
            @driver.find_element(:id, 'testingTextArea')
        end
    end
end