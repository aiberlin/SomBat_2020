"~/Seafile/AI_NTMI/SomBat/SomBat2020/sc/".openOS;

SomBat2020 - state April 2020

testing:

// 1. install Quarks [Modality, Vowel]

// 2. load the Modality description from
"~/Seafile/AI_NTMI/SomBat/SomBat2020/sc/SomBat-touchosc/touchosc-SomBat.desc.scd".absolutePath;
MKtlDesc.descFolders[1].openOS;

// 3. make sure to cache it in:
MKtlDesc.writeCache; // !!!   UPD ATE !!!

// 4. on TouchOSC, load this file thru the TouchOSC Editor:
"https://hexler.net/products/touchosc".openOS;
// open this file and click "synch". quite easy.
"~/Seafile/AI_NTMI/SomBat/SomBat2020/sc/SomBat-touchosc/SomBat2.touchosc".absolutePath;

// 5. load the 3 first synth sounds
s.waitForBoot{ 	"1-SomBat2-synthSounds.scd".loadRelative;  };
NdefMixer(s);

// 6. load the Modality Kram
s.waitForBoot{ 	"2-osc-mapping-modality.scd".loadRelative;  };

// adc network iphone addr
q.mktl.device.updateSrcDstAddr("192.168.178.55");

// 2 Q's reg the Modality item:

// ----1: how to parse the joypad data; it sends [\xy, numberForX, numberForY]. couldn't figure out how to disentangle them. Getting only y
// ----2: how to clean up the GUI? // u will see, there's some cleanup to do. Widgets shd be untereinander, as in real TouchOSC:
"touchosc screen.jpg".resolveRelative.openOS;

DANKE!!