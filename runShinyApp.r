message('library paths:\n', paste('...', .libPaths(), sep="", collapse="\n"))

chrome.portable = file.path(getwd(), 'GoogleChromePortable/App/Chrome-bin/chrome.exe')

launch.browser = function(appUrl, browser.path = chrome.portable) {
	message('Browser Path: ', browser.path)
	shell(sprintf('"%s" --app=%s', browser.path, appUrl))
}

shiny::runApp('./src/source/', launch.browser = launch.browser)