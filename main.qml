import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.12

Window {
    id: alice_w
    width: 600
    height: 450
    visible: true
    title: qsTr("Alice")

    Text {
        text: 'Алиса'
        font.pointSize: 20
        font.bold: true
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: 30
    }

    Column {
        anchors.fill: parent
        anchors.margins: 50
        anchors.topMargin: 100
        spacing: 25

        TextField {
            id: alice_m
            anchors.horizontalCenter: parent.horizontalCenter
            height: 50
            width: 300
            placeholderText: 'Сообщение M'
            horizontalAlignment: Text.AlignHCenter
            font.pointSize: 14
            onAccepted: { focus = false; }
        }

        TextField {
            id: alice_r
            anchors.horizontalCenter: parent.horizontalCenter
            height: 50
            width: 300
            placeholderText: 'Битовая цепочка R'
            horizontalAlignment: Text.AlignHCenter
            font.pointSize: 14
            onAccepted: { focus = false; }
        }

        TextField {
            id: alice_k
            height: 50
            anchors.horizontalCenter: parent.horizontalCenter
            horizontalAlignment: Text.AlignHCenter
            width: 300
            placeholderText: 'Ключ K'
            font.pointSize: 14
            onAccepted: { focus = false; }

            Button {
                id: alice_k_g
                text: 'G'
                height: 50
                width: height
                font.pointSize: 14
                anchors.right: parent.left
                anchors.rightMargin: 35
                background: Rectangle { border.width: 1; radius: height/2; border.color: 'grey';
                    color: alice_k_g.down ? '#ededed' : 'white' }
                onReleased: {
                    alice_k.text = crypter.generate();
                }
            }

            Button {
                id: alice_k_s
                enabled: alice_k.text != ''
                text: 'S'
                height: 50
                width: height
                font.pointSize: 14
                anchors.left: parent.right
                anchors.leftMargin: 35
                background: Rectangle { border.width: 1; radius: height/2; border.color: 'grey';
                    color: alice_k_s.down ? '#ededed' : 'white' }
                onReleased: {
                    bob_k.text = alice_k.text;
                    time_to_send.stop();
                    timer_text.visible = false;
                    timer_text.text = '10';
                }

                Timer {
                    id: time_to_send
                    interval: 1000
                    repeat: true
                    onTriggered: {
                        timer_text.text = String(Number(timer_text.text)-1);
                        if (timer_text.text === '0')
                        {
                            stop();
                            timer_text.visible = false;
                            timer_text.text = '10';
                            bob_k.text = alice_k.text;
                        }
                    }
                }

                Text {
                    id: timer_text
                    visible: false
                    anchors.left: parent.right
                    anchors.bottom: parent.top
                    font.pointSize: 14
                    text: '10'
                }
            }
        }

        TextField {
            id: alice_e
            height: 50
            anchors.horizontalCenter: parent.horizontalCenter
            horizontalAlignment: Text.AlignHCenter
            width: 300
            placeholderText: 'Криптограмма Е'
            font.pointSize: 14
            onAccepted: { focus = false; }

            Button {
                enabled: alice_k.text != '' && alice_m.text != ''
                id: alice_e_e
                text: 'E'
                height: 50
                width: height
                font.pointSize: 14
                anchors.right: parent.left
                anchors.rightMargin: 35
                background: Rectangle { border.width: 1; radius: height/2; border.color: 'grey';
                    color: alice_e_e.down ? '#ededed' : 'white' }
                onReleased: { parent.text = crypter.encrypt(alice_m.text + ' ' + alice_r.text, alice_k.text); }
            }

            Button {
                id: alice_e_s
                enabled: alice_e.text != ''
                text: 'S'
                height: 50
                width: height
                font.pointSize: 14
                anchors.left: parent.right
                anchors.leftMargin: 35
                background: Rectangle { border.width: 1; radius: height/2; border.color: 'grey';
                    color: alice_e_s.down ? '#ededed' : 'white' }
                onReleased: {
                    bob_e.text = alice_e.text;
                    time_popup.open();
                }
            }
        }

        Popup {
            id: time_popup
            anchors.centerIn: parent
            height: 220
            width: 250
            modal: true
            enter: Transition {
                NumberAnimation { property: "opacity"; from: 0.0; to: 1.0 }
            }
            exit: Transition {
                NumberAnimation { property: "opacity"; from: 1.0; to: 0.0 }
            }
            Text {
                id: _t
                text: 'Время до отправки (сек)'
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: parent.top
                anchors.topMargin: 10
                font.pointSize: 14
            }

            TextField {
                id: time_field
                anchors.top: _t.bottom
                anchors.topMargin: 25
                height: 50
                width: 140
                font.pointSize: 14
                horizontalAlignment: TextField.AlignHCenter
                anchors.horizontalCenter: parent.horizontalCenter
                validator: RegExpValidator { regExp: /[0-9]+/ }
            }

            Button {
                id: time_btn
                height: 50
                width: 140
                text: 'Принять'
                anchors.top: time_field.bottom
                anchors.topMargin: 25
                anchors.horizontalCenter: parent.horizontalCenter
                font.pointSize: 14
                background: Rectangle { border.width: 1; radius: 5; border.color: 'grey';
                    color: time_btn.down ? '#ededed' : 'white' }
                onReleased: {
                    timer_text.text = time_field.text;
                    timer_text.visible = true;
                    time_to_send.start();
                    time_popup.close();
                }
            }
        }
    }

    Window {
        id: bob_w
        width: 600
        height: 400
        visible: true
        title: qsTr("Bob")

        Text {
            text: 'Боб'
            font.pointSize: 20
            font.bold: true
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.topMargin: 30
        }

        Column {
            anchors.fill: parent
            anchors.margins: 50
            anchors.topMargin: 100
            spacing: 25

            TextField {
                id: bob_r
                anchors.horizontalCenter: parent.horizontalCenter
                height: 50
                width: 300
                placeholderText: 'Битовая цепочка R'
                horizontalAlignment: Text.AlignHCenter
                font.pointSize: 14
                validator: RegExpValidator { regExp: /[01]+/ }
                onAccepted: { focus = false; }

                Button {
                    id: bob_r_g
                    text: 'G'
                    height: 50
                    width: height
                    font.pointSize: 14
                    anchors.right: parent.left
                    anchors.rightMargin: 35
                    background: Rectangle { border.width: 1; radius: height/2; border.color: 'grey';
                        color: bob_r_g.down ? '#ededed' : 'white' }
                    onReleased: {
                        var res = '';
                        for (var i = 0; i < 16; i++)
                        {
                            res += String(Math.floor(Math.random()*2));
                        }
                        parent.text = res;
                    }
                }

                Button {
                    id: bob_r_s
                    enabled: bob_r.text != ''
                    text: 'S'
                    height: 50
                    width: height
                    font.pointSize: 14
                    anchors.left: parent.right
                    anchors.leftMargin: 35
                    background: Rectangle { border.width: 1; radius: height/2; border.color: 'grey';
                        color: bob_r_s.down ? '#ededed' : 'white' }
                    onReleased: { alice_r.text = parent.text; }
                }
            }

            TextField {
                id: bob_k
                height: 50
                anchors.horizontalCenter: parent.horizontalCenter
                horizontalAlignment: Text.AlignHCenter
                width: 300
                placeholderText: 'Ключ K'
                font.pointSize: 14
                onAccepted: { focus = false; }
            }

            TextField {
                id: bob_e
                height: 50
                anchors.horizontalCenter: parent.horizontalCenter
                horizontalAlignment: Text.AlignHCenter
                width: 300
                placeholderText: 'Криптограмма Е'
                font.pointSize: 14
                onAccepted: { focus = false; }

                Button {
                    id: bob_e_d
                    enabled: bob_e.text != '' && bob_k.text != ''
                    text: 'D'
                    height: 50
                    width: height
                    font.pointSize: 14
                    anchors.left: parent.right
                    anchors.leftMargin: 35
                    background: Rectangle { border.width: 1; radius: height/2; border.color: 'grey';
                        color: bob_e_d.down ? '#ededed' : 'white' }
                    onReleased: {
                        msg.text = crypter.decrypt(parent.text, bob_k.text);
                        result.open();
                    }
                }
            }
        }

        Popup {
            id: result
            anchors.centerIn: parent
            height: parent.height
            width: parent.width

            background: Rectangle { color: 'white' }

            enter: Transition {
                NumberAnimation { property: "opacity"; from: 0.0; to: 1.0 }
            }
            exit: Transition {
                NumberAnimation { property: "opacity"; from: 1.0; to: 0.0 }
            }

            Text {                
                text: 'Результат расшифрования'
                font.pointSize: 20
                font.bold: true
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: parent.top
                anchors.topMargin: 60
            }

            Text {
                id: msg
                color: text === 'Невозможно расшифровать' ? 'red' : 'black'
                font.pointSize: 14
                horizontalAlignment: Text.AlignHCenter
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.margins: 40
                anchors.topMargin: 150
            }

            Text {
                visible: msg.text != 'Невозможно расшифровать'
                anchors.top: msg.bottom
                anchors.topMargin: 50
                anchors.horizontalCenter: parent.horizontalCenter
                font.pointSize: 14
                color: include(msg.text, bob_r.text) ? 'green' : 'red'
                text: include(msg.text, bob_r.text) ? 'Цепочка соответствует отправленной' : 'Цепочка не соответствует отправленной'
            }
        }
    }

    function include(src, check)
    {
        var source = String(src);
        var b = source.endsWith(String(check));
        return b;
    }
}
