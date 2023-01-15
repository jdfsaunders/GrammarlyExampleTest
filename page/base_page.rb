module Page
    class BasePage
        @driver
        @wait

        def initialize(driver, wait)
            @driver = driver
            @wait = wait
        end

        def navigate(url)
            @driver.navigate.to(url)
        end

    end
end
