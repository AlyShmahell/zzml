from zzml import zzml

print(
    zzml(
        """
        <?xml version="1.0" encoding="UTF-8"?>
        <ssml>
            <speak>
                <p>
                    <break time="1s"> </break>
                    Hello, this is an example of a complex SSML document.
                    <emphasis level="strong">This text will be spoken with strong emphasis.</emphasis>
                    <prosody rate="slow">This text will be spoken at a slower pace.</prosody>
                    <p>
                    <break time="2s"> </break>
                        This is a paragraph break with a 2-second pause.
                        <say-as interpret-as="date">January 1, 2022</say-as>
                        <say-as interpret-as="time">12:30 PM</say-as>
                    </p>
                    <p>
                        <break time="1s"> </break>
                        This is another paragraph with a 1-second pause.
                        <phoneme alphabet="ipa" ph="tɪm ɪz ən ɔðər pɑrəɡræf">This is another paragraph.</phoneme>
                    </p>
                </p>
            </speak>
        </ssml>
        """
    )
)
