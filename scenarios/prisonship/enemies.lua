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
        angle = -0.062322847545147,
        connections = { {
            angle = 0.073561526834965,
            connections = { nil, "parent", {
                angle = 4.607081413269,
                connections = { "parent" },
                name = "Thruster",
                x = -49.4072265625,
                y = -52.995086669922
            }, {
                angle = -4.6772856712341,
                connections = { "parent" },
                name = "Cannon",
                x = -50.905639648438,
                y = 48.908782958984
            } },
            name = "Connector1x1",
            x = -48.942932128906,
            y = -1.1985321044922
        }, {
            angle = 0.031905092298985,
            connections = { "parent", nil, {
                angle = -1.5308872461319,
                connections = { "parent" },
                name = "Thruster",
                x = 52.974853515625,
                y = -52.081130981445
            }, {
                angle = -11.09393119812,
                connections = { "parent" },
                name = "Cannon",
                x = 52.335388183594,
                y = 48.815185546875
            } },
            name = "Connector1x1",
            x = 49.983520507813,
            y = -0.44868469238281
        } },
        name = "Enemy",
        x = 0,
        y = 0
    },

    bird = {
        angle = 0.35901471972466,
        connections = { {
            angle = 0.36213326454163,
            connections = { {
                angle = 0.10707872360945,
                connections = { {
                    angle = -0.39919751882553,
                    connections = { {
                        angle = -0.14427986741066,
                        connections = { {
                            angle = 0.31292560696602,
                            connections = { nil, "parent" },
                            name = "Connector1x1",
                            x = 299.87322998047,
                            y = 272.41448974609
                        }, "parent" },
                        name = "Connector1x1",
                        x = 348.0876159668,
                        y = 276.80514526367
                    }, "parent" },
                    name = "Connector1x1",
                    x = 396.65249633789,
                    y = 268.41665649414
                }, "parent" },
                name = "Connector1x1",
                x = 444.9423828125,
                y = 264.95452880859
            }, "parent", {
                angle = -1.1082481145859,
                connections = { "parent" },
                name = "Thruster",
                x = 510.82318115234,
                y = 235.70405578613
            }, {
                angle = -10.427696228027,
                connections = { "parent" },
                name = "Cannon",
                x = 471.52612304688,
                y = 319.60968017578
            } },
            name = "Connector1x1",
            x = 492.43594360352,
            y = 277.80416870117
        }, {
            angle = 0.15381947159767,
            connections = { "parent", {
                angle = -0.16727118194103,
                connections = { "parent", {
                    angle = -0.096965692937374,
                    connections = { "parent", {
                        angle = -0.68769955635071,
                        connections = { "parent", {
                            angle = -1.0955051183701,
                            connections = { "parent" },
                            name = "Connector1x1",
                            x = 750.49206542969,
                            y = 239.06784057617
                        } },
                        name = "Connector1x1",
                        x = 721.87866210938,
                        y = 277.0500793457
                    } },
                    name = "Connector1x1",
                    x = 675.15447998047,
                    y = 295.65435791016
                } },
                name = "Connector1x1",
                x = 627.81597900391,
                y = 302.76397705078
            }, {
                angle = -1.3661158084869,
                connections = { "parent" },
                name = "Thruster",
                x = 588.30340576172,
                y = 259.97274780273
            }, {
                angle = -4.4189491271973,
                connections = { "parent" },
                name = "Cannon",
                x = 569.32873535156,
                y = 350.83471679688
            } },
            name = "Connector1x1",
            x = 580.07336425781,
            y = 304.86791992188
        } },
        name = "Enemy",
        x = 534.89904785156,
        y = 292.74163818359
    }
}
