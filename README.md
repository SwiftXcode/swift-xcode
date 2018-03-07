<h2>swift-xcode
  <img src="http://zeezide.com/img/SwiftXcodePkgIcon.svg"
       align="right" width="128" height="128" />
</h2>

![Swift4](https://img.shields.io/badge/swift-4-blue.svg)
![macOS](https://img.shields.io/badge/os-macOS-green.svg?style=flat)
[![homebrew](https://img.shields.io/homebrew/v/cake.svg)](https://github.com/SwiftXcode/homebrew-swiftxcode)

Use Swift packages directly from within Xcode,
w/o having to jump to the Terminal.
With swift builds, in a non-annoying way.
Build large dependencies once, not for every project.
Do not require an Internet connection just to create a new project.

<p style="text-align: right;"><i>... hopefully getting sherlocked soon!</i></p>

Too much text? Want a GIF? [Here you go](https://swiftxcode.github.io#what-it-looks-like-).

## Goals

### 1. Use Swift Package Manager directly from within Xcode

Goal (duration: a few seconds):
1. Create a project from within Xcode. (Cmd-Shift-N, follow wizard)
2. Build and run. Works.
You need to add a package? Just edit `Package.swift` and build.

State of the art (duration: some minutes or more):
1. Open terminal.
2. Call `mkdir MyProject`. Do a `cd MyProject`.
3. Call `swift package init`, `kitura init`, or something similar.
4. Call `swift package generate-xcodeproj` to create the Xcode project.
5. Open `MyProject.xcodeproj`, find and select the right scheme
6. Build and Run.
You need to add a package? Start again at step 4, sometimes 3.

### 2. Reduce Compile Time

Calling `swift build` as a tool is somewhat expensive.

Goal:
Instead of doing calling `swift build` on every build,
do a `swift build` only if the `Package.swift` changes.
Produces a static library (pretty big, bundles up all the packages),
which is directly linked against the Xcode target.

### 3. Reduce *Initial* Compile Time

State of the art:
When you create a new Swift Package Manager project,
for instance a Kitura endpoint,
the initial setup takes a long time:
1. all the required packages are resolved and fetched from the Internet
2. all those packages are built from source

For a plain Kitura HelloWorld this is about 3-5 minutes before you can get
going, even on a fast machine.

But worse: This has to be done every single time you create a new project!
Want to create HelloKitten? Another 3mins lost. HelloCow? Again.

Goals, alongside goal 1:
1. Create a project from within Xcode. (Cmd-Shift-N, follow wizard)
2. Edit your main.swift or whatever
3. Build and run. Only build your own project sources.

#### 3.1. Bonus: Do not require Internet to create new projects

Internet is only required when you install an image, once.
After that, the bundled image is available and as many projects as desired
can be created.


## Installation

```shell
brew tap swiftxcode/swiftxcode
brew install swift-xcode
swift xcode link-templates # <-- important!
```


### Extra Images

Images are pairs of Xcode templates and precompiled Swift packages 
(used by those templates).
The precompilation happens when you install a Homebrew image formula
(or manually using the GIT repo) and can take some time.
Afterwards you can create new Xcode projects using those templates,
without having to wait for the SPM bootstrap (fetch and compilation
of the dependencies).

#### Image: Kitura

(One time) compile time: ~5 minutes. Image size: ~100MB.
Fresh project setup from create to run: 3 seconds.

```shell
brew install swift-xcode-kitura
swift xcode link-templates # <-- important!
```


## Using it for iOS Projects

Here is the basic version:

1. Create new Project in Xcode (File Menu / New / Project)
2. Select iOS / Swift Package Manager App
3. Give it a name, optionally preconfigure SPM modules you want
4. Build project (can take a moment w/o an image)
5. In Package.swift, add modules as you wish, e.g. `cows`
6. in AppDelegate.swift, `import cows`, do `print(cows.vaca())`
7. Build project and run


## Manual Setup

The functionality can be added to any existing project,
there is no requirement to use the templates.

Steps:
- Create a `Package.swift` in your project,
  DO NOT ADD it to the Xcode target
- Add an Xcode shell buildstep to your target, put it at the very top.
  Within that, invoke `swift xcode build`
  (optionally prefixed by an `SPM_IMAGE=ImageYouWantToUse`)
- Add some build settings (either in Xcode or in an xcconfig file):
  - "Header Search Paths" / `HEADER_SEARCH_PATHS`
    - `$(SRCROOT)/$(PRODUCT_NAME)/.buildzz/.build/Xcode/$(PLATFORM_PREFERRED_ARCH)-apple-$(SWIFT_PLATFORM_TARGET_PREFIX)$($(DEPLOYMENT_TARGET_SETTING_NAME))/$(CONFIGURATION)`
  - "Import Paths" (Swift) / `SWIFT_INCLUDE_PATHS`
    - `$(SRCROOT)/$(PRODUCT_NAME)/.buildzz/.build/$(PLATFORM_PREFERRED_ARCH)-apple-$(SWIFT_PLATFORM_TARGET_PREFIX)$($(DEPLOYMENT_TARGET_SETTING_NAME))/$(CONFIGURATION)`
  - "Library Search Paths" / `LIBRARY_SEARCH_PATHS`
    - `$(SRCROOT)/$(PRODUCT_NAME)/.buildzz/.build/Xcode/$(PLATFORM_PREFERRED_ARCH)-apple-$(SWIFT_PLATFORM_TARGET_PREFIX)$($(DEPLOYMENT_TARGET_SETTING_NAME))/$(CONFIGURATION)`
  - "Other Linker Flags" / `OTHER_LDFLAGS`
    - `-lXcodeSPMDependencies`

If you do this a lot and you don't want to use the templates,
create an `xcconfig` file to carry the settings,
and just add that to your project.
We also provide an xcconfig you can use/include:
`/usr/local/lib/xcconfig/swift-xcode.xcconfig`.


## Status

Supposed to work fine, patches welcome!


## Comparison w/ other Package Managers

Note that `swift-xcode` is not really a package manager on its own.
The package manager is still the official
[Swift Package Manager](https://swift.org/package-manager/),
just enhanced a little.

So you inherit a lot of its limitations.
For example it cannot deal with resources,
produce frameworks, or bundles.
Yet, you can still build reusable modules with it.

So is it a replacement for Cocoa Pods or Carthage?
In some cases it can be. In other cases it can't :-)


### FAQ

- Q: Does that make sense?
  - A: You [tell us](https://twitter.com/ar_institute)!
- Q: Does it work on iOS projects? macOS?
  - A: Yes! You cannot build an iOS or macOS app using SPM itself, 
       but using this you can create reusable modules which you import
       into your iOS app.
- Q: Those static libraries and images are BIG! Isn't that an issue?
  - A: Well, they have the same size they would otherwise have :-)
       Since they are static libraries, the linker will cherrypick
       the requires components, meaning your binary *won't* be
       own-stuff plus static-lib size, but just own-stuff plus stuff-you-use.
- Q: What if I have multiple Xcode versions installed?
  - A: This should generally work fine. Images are scoped by the Swift
       version.
       However, if you switch the Swift version, you may have to first build
       a shared image (it will still work w/o, but it will be slow on 1st setup
       as usual).


### SPM Modules to Try

- [µExpress](http://www.alwaysrightinstitute.com/microexpress/)
- [cows](https://github.com/AlwaysRightInstitute/cows)
- [mustache](https://github.com/AlwaysRightInstitute/mustache)
- [Euro](https://github.com/AlwaysRightInstitute/Euro)
- [Swift Server Working Group HTTP API](https://github.com/swift-server/http)


### Links

- Even though it works very different and shares no code,
  this is originally inspired by [CWL SPM Fetch](https://www.cocoawithlove.com/blog/package-manager-fetch.html)
- [Swift Package Manager](https://swift.org/package-manager/)
- Ray Wenderlich: [An Introduction to the Swift Package Manager](https://www.raywenderlich.com/148832/introduction-swift-package-manager)

### Who

Brought to you by
[The Always Right Institute](http://www.alwaysrightinstitute.com)
and
[ZeeZide](http://zeezide.de).
We like
[feedback](https://twitter.com/ar_institute),
GitHub stars,
cool [contract work](http://zeezide.com/en/services/services.html),
presumably any form of praise you can think of.
