[
    {
        "id": "34cea2e2d8f386b4",
        "type": "mqtt out",
        "z": "52d6d2959bf890b4",
        "name": "",
        "topic": "fromNodeRed",
        "qos": "",
        "retain": "",
        "respTopic": "",
        "contentType": "",
        "userProps": "",
        "correl": "",
        "expiry": "",
        "broker": "b588965e00983323",
        "x": 340,
        "y": 60,
        "wires": []
    },
    {
        "id": "adc4c9bac8b815a7",
        "type": "inject",
        "z": "52d6d2959bf890b4",
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
        "payload": "{\"cmd\":\"DW\",\"pin\":\"D1\",\"value\":0}",
        "payloadType": "json",
        "x": 140,
        "y": 100,
        "wires": [
            [
                "34cea2e2d8f386b4"
            ]
        ]
    },
    {
        "id": "b696b434fc99e1df",
        "type": "inject",
        "z": "52d6d2959bf890b4",
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
        "payload": "{\"cmd\":\"DW\",\"pin\":\"D1\",\"value\":1}",
        "payloadType": "json",
        "x": 130,
        "y": 40,
        "wires": [
            [
                "34cea2e2d8f386b4"
            ]
        ]
    },
    {
        "id": "ccf0c95b97b430b7",
        "type": "mqtt in",
        "z": "52d6d2959bf890b4",
        "name": "",
        "topic": "toNodeRed",
        "qos": "0",
        "datatype": "auto-detect",
        "broker": "b588965e00983323",
        "nl": false,
        "rap": true,
        "rh": 0,
        "inputs": 0,
        "x": 130,
        "y": 200,
        "wires": [
            [
                "118b47d7199ab47e"
            ]
        ]
    },
    {
        "id": "118b47d7199ab47e",
        "type": "debug",
        "z": "52d6d2959bf890b4",
        "name": "debug 2",
        "active": false,
        "tosidebar": true,
        "console": false,
        "tostatus": false,
        "complete": "false",
        "statusVal": "",
        "statusType": "auto",
        "x": 340,
        "y": 200,
        "wires": []
    },
    {
        "id": "b588965e00983323",
        "type": "mqtt-broker",
        "name": "Handy",
        "broker": "192.168.134.90",
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
