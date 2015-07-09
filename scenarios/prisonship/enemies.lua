return {
    scout = {
        angle = 0.002870105439797,
        connections = {
            [3] = {
                angle = -1.5955518484116,
                connections = { "parent" },
                name = "Thruster",
                x = 425.36346435547,
                y = 231.00605773926
            },
            [4] = {
                angle = -4.7712035179138,
                connections = { "parent" },
                name = "Cannon",
                x = 425.32202148438,
                y = 323.9616394043
            }
        },
        name = "Enemy",
        x = 424.97790527344,
        y = 277.00601196289
    },
    drone = {
        angle = -0.0043949773535132,
        connections = { {
            angle = -0.00065135821932927,
            connections = { nil, "parent", {
                angle = -1.5362768173218,
                connections = { "parent" },
                name = "Thruster",
                x = 388.81307983398,
                y = 223.01838684082
            }, {
                angle = -10.959948539734,
                connections = { "parent" },
                name = "Cannon",
                x = 387.14514160156,
                y = 315.98477172852
            } },
            name = "Connector1x1",
            x = 387.99475097656,
            y = 269.00466918945
        }, {
            angle = -0.011771964840591,
            connections = { "parent", nil, {
                angle = -1.6493122577667,
                connections = { "parent" },
                name = "Thruster",
                x = 478.1686706543,
                y = 222.07543945313
            }, {
                angle = -4.6382350921631,
                connections = { "parent" },
                name = "Cannon",
                x = 478.22186279297,
                y = 314.93402099609
            } },
            name = "Connector1x1",
            x = 479.99749755859,
            y = 267.68090820313
        } },
        name = "Enemy",
        x = 432.99490356445,
        y = 267.88565063477
    }
}
