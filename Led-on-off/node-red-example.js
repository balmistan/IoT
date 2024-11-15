[
    {
        "id": "10392be039c9d1b1",
        "type": "tab",
        "label": "NodeMCU Led Json",
        "disabled": false,
        "info": "",
        "env": []
    },
    {
        "id": "7b7e46ec1a0c3394",
        "type": "mqtt out",
        "z": "10392be039c9d1b1",
        "name": "",
        "topic": "toDevice_0",
        "qos": "",
        "retain": "",
        "respTopic": "",
        "contentType": "",
        "userProps": "",
        "correl": "",
        "expiry": "",
        "broker": "b588965e00983323",
        "x": 1030,
        "y": 240,
        "wires": []
    },
    {
        "id": "1c1414db87639320",
        "type": "inject",
        "z": "10392be039c9d1b1",
        "name": "OFF-D0",
        "props": [
            {
                "p": "payload"
            },
            {
                "p": "topic",
                "vt": "str"
            }
        ],
        "repeat": "",
        "crontab": "",
        "once": false,
        "onceDelay": 0.1,
        "topic": "",
        "payload": "{\"cmd\":\"DW\",\"gpio\":16,\"value\":0}",
        "payloadType": "json",
        "x": 380,
        "y": 100,
        "wires": [
            [
                "7b7e46ec1a0c3394"
            ]
        ]
    },
    {
        "id": "340f8a3780dc2fa9",
        "type": "inject",
        "z": "10392be039c9d1b1",
        "name": "ON-D0",
        "props": [
            {
                "p": "payload"
            },
            {
                "p": "topic",
                "vt": "str"
            }
        ],
        "repeat": "",
        "crontab": "",
        "once": false,
        "onceDelay": 0.1,
        "topic": "",
        "payload": "{\"cmd\":\"DW\",\"gpio\":16,\"value\":1}",
        "payloadType": "json",
        "x": 370,
        "y": 40,
        "wires": [
            [
                "7b7e46ec1a0c3394"
            ]
        ]
    },
    {
        "id": "2284fdd1742259f3",
        "type": "mqtt in",
        "z": "10392be039c9d1b1",
        "name": "",
        "topic": "toNodeRed",
        "qos": "0",
        "datatype": "auto-detect",
        "broker": "b588965e00983323",
        "nl": false,
        "rap": true,
        "rh": 0,
        "inputs": 0,
        "x": 370,
        "y": 700,
        "wires": [
            [
                "86d714a5c306b917"
            ]
        ]
    },
    {
        "id": "86d714a5c306b917",
        "type": "debug",
        "z": "10392be039c9d1b1",
        "name": "debug 2",
        "active": false,
        "tosidebar": true,
        "console": false,
        "tostatus": false,
        "complete": "false",
        "statusVal": "",
        "statusType": "auto",
        "x": 580,
        "y": 700,
        "wires": []
    },
    {
        "id": "8fdc45f99e419078",
        "type": "inject",
        "z": "10392be039c9d1b1",
        "name": "Analog D1 100",
        "props": [
            {
                "p": "payload"
            },
            {
                "p": "topic",
                "vt": "str"
            }
        ],
        "repeat": "",
        "crontab": "",
        "once": false,
        "onceDelay": 0.1,
        "topic": "",
        "payload": "{\"cmd\":\"AW\",\"gpio\":5,\"value\":100}",
        "payloadType": "json",
        "x": 400,
        "y": 380,
        "wires": [
            [
                "7b7e46ec1a0c3394"
            ]
        ]
    },
    {
        "id": "1e2824570dc5291d",
        "type": "inject",
        "z": "10392be039c9d1b1",
        "name": "Analog D1 200",
        "props": [
            {
                "p": "payload"
            },
            {
                "p": "topic",
                "vt": "str"
            }
        ],
        "repeat": "",
        "crontab": "",
        "once": false,
        "onceDelay": 0.1,
        "topic": "",
        "payload": "{\"cmd\":\"AW\",\"gpio\":5,\"value\":200}",
        "payloadType": "json",
        "x": 400,
        "y": 440,
        "wires": [
            [
                "7b7e46ec1a0c3394"
            ]
        ]
    },
    {
        "id": "e512564dbe855c1f",
        "type": "inject",
        "z": "10392be039c9d1b1",
        "name": "ON-D1",
        "props": [
            {
                "p": "payload"
            },
            {
                "p": "topic",
                "vt": "str"
            }
        ],
        "repeat": "",
        "crontab": "",
        "once": false,
        "onceDelay": 0.1,
        "topic": "",
        "payload": "{\"cmd\":\"DW\",\"gpio\":5,\"value\":1}",
        "payloadType": "json",
        "x": 370,
        "y": 320,
        "wires": [
            [
                "7b7e46ec1a0c3394"
            ]
        ]
    },
    {
        "id": "332cf81180705e07",
        "type": "inject",
        "z": "10392be039c9d1b1",
        "name": "OFF-D1",
        "props": [
            {
                "p": "payload"
            },
            {
                "p": "topic",
                "vt": "str"
            }
        ],
        "repeat": "",
        "crontab": "",
        "once": false,
        "onceDelay": 0.1,
        "topic": "",
        "payload": "{\"cmd\":\"DW\",\"gpio\":5,\"value\":0}",
        "payloadType": "json",
        "x": 380,
        "y": 500,
        "wires": [
            [
                "7b7e46ec1a0c3394"
            ]
        ]
    },
    {
        "id": "b588965e00983323",
        "type": "mqtt-broker",
        "name": "Handy",
        "broker": "http://192.168.248.90/",
        "port": "1883",
        "clientid": "",
        "autoConnect": true,
        "usetls": false,
        "protocolVersion": "4",
        "keepalive": "60",
        "cleansession": true,
        "autoUnsubscribe": true,
        "birthTopic": "",
        "birthQos": "0",
        "birthRetain": "false",
        "birthPayload": "",
        "birthMsg": {},
        "closeTopic": "",
        "closeQos": "0",
        "closeRetain": "false",
        "closePayload": "",
        "closeMsg": {},
        "willTopic": "",
        "willQos": "0",
        "willRetain": "false",
        "willPayload": "",
        "willMsg": {},
        "userProps": "",
        "sessionExpiry": ""
    }
]
