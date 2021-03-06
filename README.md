# Snowman

Snowman is a simple Apple Watch game. The objective is to draw letters to guess the word or phrase before the snowman melts.

<p align="center">
<img src="Resources/snowman-screenshots.png") alt="Snowman for Apple Watch"/>
</p>

## Purpose

Snowman was built to demonstrate using CoreML to build a game for watchOS 4. The project includes an Apple Watch app and several scripts to train handwriting recognition models that are compatible with CoreML.

## Presentation

- Snowman was built as a companion app to demonstrate new watchOS 4 features, and as an example of how to use CoreML on watchOS. 
- The presentation that describes how Snowman was built and many other capabilities of watchOS 4 can be found [here](https://speakerdeck.com/cnstoll/the-latest-in-developing-for-watchos) and [here](https://speakerdeck.com/cnstoll/machine-learning-on-apple-watch).

## Building Snowman

- Snowman requires Xcode 9 (latest version), iOS 11, and watchOS 4

## Machine Learning

- Snowman uses a handwriting recognition model trained on the Extended MNIST data set. 
- For more information on training a handwriting recognition model, check out the README and scripts located in the Training folder.

## Known Issues

- SpriteKit doesn't load initially for interface controllers on watchOS 4 Beta 5. To resolve, background the app when the spinner appears and then re-open it and the interface controller will load. (Fixed in Beta 6)

# Credits

- Data Science: [Kathryn Bonnen](https://github.com/kbonnen)
- Developer: [Conrad Stoll](https://github.com/cnstoll)
- Icon Design: [Ryan Considine](https://twitter.com/ryanconsidine)
