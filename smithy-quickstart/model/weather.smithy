$version: "2"
namespace example.weather

/// Provides weather forecasts.
service Weather {
    version: "2006-03-01"
    resources: [
        City
    ]
}

// "pattern" is a trait.
@pattern("^[A-Za-z0-9 ]+$")
string CityId

resource City {
    identifiers: { cityId: CityId }
    properties: { coordinates: CityCoordinates }
    read: GetCity
    resources: [
        Forecast
    ]
}

structure CityCoordinates {
    @required
    latitude: Float

    @required
    longitude: Float
}


resource Forecast {
    identifiers: { cityId: CityId }
    properties: { chanceOfRain: Float }
    read: GetForecast
}

structure GetForecastOutput for Forecast {
    $chanceOfRain
}

@readonly
operation GetCity {
    input := for City {
        // "cityId" provides the identifier for the resource and
        // has to be marked as required.
        @required
        $cityId
    }

    output := for City {
        // "required" is used on output to indicate if the service
        // will always provide a value for the member.
        // "notProperty" indicates that top-level input member "name"
        // is not bound to any resource property.
        @required
        @notProperty
        name: String

        @required
        $coordinates
    }

    errors: [
        NoSuchResource
    ]
}

// "error" is a trait that is used to specialize
// a structure as an error.
@error("client")
structure NoSuchResource {
    @required
    resourceType: String
}

@readonly
operation GetForecast {
    // "cityId" provides the only identifier for the resource since
    // a Forecast doesn't have its own.
    input := for Forecast {
        @required
        $cityId
    }

    output := for Forecast {
        $chanceOfRain
    }
}


