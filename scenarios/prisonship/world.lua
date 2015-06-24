return {
    roomTypes = {
        L = 'lookout',
        D = 'deck',
        I = 'interior',
        H = 'hold',
    },
    start = {
        floor = 3,
        col = 6,
        row = 3
    },
    floorWidth = 10,
    floorHeight = 5,
    floors = {
        [1] = {
            name = 'Lookout',
            rooms = {
                ' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',
                ' ',' ',' ','L',' ',' ',' ','L',' ',' ',
                ' ',' ','L','L',' ',' ',' ','L','L',' ',
                ' ',' ',' ','L',' ',' ',' ','L',' ',' ',
                ' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',
            }
        },

        [2] = {
            name = 'Upper Deck',
            rooms = {
                ' ',' ','D','D',' ',' ',' ','D','D',' ',
                ' ','D','D','D',' ',' ',' ','D','D','D',
                'D','D','D','D',' ',' ',' ','D','D','D',
                ' ','D','D','D',' ',' ',' ','D','D','D',
                ' ',' ','D','D',' ',' ',' ','D','D',' ',
            }
        },

        [3] = {
            name = 'Middle deck and first floor',
            rooms = {
                ' ',' ','I','I','D','D','D','I','I',' ',
                ' ','I','I','I','D','D','D','I','I','I',
                'I','I','I','I','D','D','D','I','I','I',
                ' ','I','I','I','D','D','D','I','I','I',
                ' ',' ','I','I','D','D','D','I','I',' ',
            }
        },

        [4] = {
            name = 'Main Floor',
            rooms = {
                ' ',' ','I','I','I','I','I','I','I',' ',
                ' ','I','I','I','I','I','I','I','I','I',
                'I','I','I','I','I','I','I','I','I','I',
                ' ','I','I','I','I','I','I','I','I','I',
                ' ',' ','I','I','I','I','I','I','I',' ',
            }
        },

        [5] = {
            name = 'Cargo hold',
            rooms = {
                ' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',
                ' ',' ','H','H','H','H','H','H','H','H',
                ' ','H','H','H','H','H','H','H','H','H',
                ' ',' ','H','H','H','H','H','H','H','H',
                ' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',
            }
        },
    },
}