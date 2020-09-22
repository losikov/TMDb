# Functional Testing Sample Project

## Project Info
This iOS Native Mobile Application is a sample project with functional tests driven by Appium. To run the automation on your Mac [install node and yarn](https://medium.com/@losikov/part-1-project-initial-setup-typescript-node-js-31ba3aa7fbf1), open terminal, go to the project folder, and run:
```
yarn install
yarn test:build
yarn test:run
```
Check the properties in `capabilities` section of `wdio.conf.js` file, if you have any issues.

To setup the automation for this project, I followed the guide below. You can folow it as well for you project.

## Automation Setup Guide

### Requirements

[node](https://nodejs.org/en/) and [yarn](https://classic.yarnpkg.com/en/docs/install). Install using [this guide](https://medium.com/@losikov/part-1-project-initial-setup-typescript-node-js-31ba3aa7fbf1)


### Initial wdio Setup ##

1. Run the following in command line:
```
yarn add -D @wdio/cli
yarn wdio config --yarn
```

2. Choose the following options:

    * Where is your automation backend located? - **On my local machin**
    * Which framework do you want to use? - **jasmine**
    * Do you want to run WebdriverIO commands synchronous or asynchronous? - **sync**
    * Where are your test specs located? - ***leave default/blank***
    * Do you want WebdriverIO to autogenerate some test files? - **Y**
    * Do you want to use page objects (https://martinfowler.com/bliki/PageObject.html)? - **n**
    * Are you using a compiler? - **No**
    * Which reporter do you want to use?? - **spec**
    * Do you want to add a service to your test setup? - Deselect **chromedriver** select  **appium**
    * What is the base url? - ***leave default/blank***

3. Add the following scripts to package.json:
```
  "scripts": {
    "test:build": "xcodebuild -workspace ./TMDb.xcodeproj/project.xcworkspace -configuration release -scheme TMDb -sdk iphonesimulator -derivedDataPath build",
    "test:run": "wdio wdio.conf.js"
  },
```
Where:
* `./TMDb.xcodeproj/project.xcworkspace` is a path to the workscpace, 
* `TMDb` is your build schema,
* and `build` is a destination folder.

Run `yarn test:build` to build the application. Locate the the build:
```
find ./build -name "*.app"
# ./build/Build/Products/Release-iphonesimulator/TMDb.app
```

4. Update `capabilities` section in `wdio.conf.js` to the following:
```
    capabilities: [{
        maxInstances: 1,
        browserName: 'iOS',
        platformName: 'iOS',
        platformVersion: '14.0',
        deviceName: 'iPhone 11',
        automationName: 'XCUITest',
        app: `${__dirname}/build/Build/Products/Release-iphonesimulator/TMDb.app`
    }],
```
Update `platformVersion`, `deviceName`, and `app` path to the build path from step 3.

5. Run `yarn test:run`. It will take a while for the first time, as it installs `WebDriverAgent` app on your simulator.

### Run the Tests

To build the app and run the tests run from command line:
```
yarn test:build
yarn test:run
```

### Tests Scripts Development

Save your test scripts `to test/specs`.

Use [the documentation](https://webdriver.io/docs/api.html).
Use XCode => Open Developer Tool => Accessibility Inspector to locate UI elements. Set [accessibilityIdentifier](https://developer.apple.com/documentation/uikit/uiaccessibilityidentification/1623132-accessibilityidentifier?language=objc) for UI elements it is hard to get an access.


#### Example Test script for TMDb application:
```
describe('should search movies', () => {
  it('should search Men in Black', () => {
    expect($('~Search Movies')).toBeExisting();

    $('~Search Movies').setValue('Men in Black');
    expect($('~title0')).toHaveTextContaining('Men in Black');
    expect($('~title1')).toHaveTextContaining('Men in Black');
    expect($('~title2')).toHaveTextContaining('Men in Black');
    $('~Cancel').touchAction('tap')
  });
});

describe('should open movie details', () => {
  it('should open and show details for The Shawshank Redemption', () => {
    $('~Search Movies').setValue('The Shawshank Redemption');
    expect($('~title0')).toHaveTextContaining('The Shawshank Redemption');
    expect($('~overview0')).toHaveTextContaining('Framed in the 1940s');

    $('~title0').touchAction('tap')

    expect($('~title')).toHaveTextContaining('The Shawshank Redemption');
    expect($('~overview')).toHaveTextContaining('Framed in the 1940s for the double murder of his wife and her lover');

    $('~Back').touchAction('tap')
    $('~Cancel').touchAction('tap')
  });
});

```
