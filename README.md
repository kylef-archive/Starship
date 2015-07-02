<img src="https://raw.githubusercontent.com/the-hypermedia-project/Hyperdrive/master/Hyperdrive.png" />

# Starship

[![Build Status](http://img.shields.io/circleci/project/kylef/Starship/master.svg)](https://circleci.com/gh/kylef/Starship)

Starship is a generic API client application for iOS using
[Hyperdrive](https://github.com/the-hypermedia-project/Hyperdrive). It allows
you to connect and explore any Hypermedia or API Blueprint described API.

You can enter an API via a URL to a Hypermedia API or a domain name for an API
Bueprint hosted on Apiary. Starship will then present you the available
transitions on the API and allow you to explore it with a generated user
interface.

<img src="Media/Screenshot.png" width=375 height=667 alt="Screenshot of Starship application" />

## Usage

Hyperdrive allows you to enter APIs described either at run-time using
Hypermedia controls or via an API Blueprint.

### API Blueprint

Starship requires API Blueprints to use relation tags along with describing
data structures with MSON Attributes to generate the interface.

You can find an [example API Blueprint](https://github.com/apiaryio/polls-app/blob/master/apiary.apib)
(`pollsapp` on Apiary) which is designed to work with Starship's Hyperdrive.

Take a look at the [Blueprint tutorial](https://github.com/the-hypermedia-project/Hyperdrive/blob/master/Blueprint.md#blueprint)
on Hyperdrive for more info.

### Hypermedia

APIs can offer information at run-time about how they work, such as with the
[Siren](https://github.com/kevinswiber/siren) and
[HAL](http://stateless.co/hal_specification.html) content types.

## License

Starship is released under the BSD license. See [LICENSE](LICENSE).

