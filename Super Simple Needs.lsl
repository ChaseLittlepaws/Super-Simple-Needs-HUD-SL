///Variables for needs decay and text
float sleep = 100;
float food = 100;
float bathroom = 100;
float hygiene = 100;
float sleepDecay = 0.1042;
float foodDecay = 0.208;
float bladderDecay = 0.2777;
float hygieneDecay = 0.0694;
vector white = <1.0, 1.0, 1.0>;
float opaque = 1.0;

///Variables for dialog menu
string dialogInitial = "\nWhat need did you satisfy?";
string dialogFollowup = "\nHow much did you satisfy this need?";
list needsList = ["Food", "Bathroom", "Hygiene", "Sleep"];  ///ordered differently to display correctly on dialog menu
list sleepResponses = ["Sleep+", "Sleep++", "Sleep+++"];
list foodResponses = ["Food+", "Food++", "Food+++"];
list bathroomResponses = ["Bathroom+++"];
list hygieneResponses = ["Hygiene+", "Hygiene++", "Hygiene+++"];
key toucher;
integer dialogChannel;
integer listenHandle;

///Variables for HUD
integer sleepBarLink = 2;
integer foodBarLink = 3;
integer bathroomBarLink = 4;
integer hygieneBarLink = 5;
vector sleepBarSize = <0.500, 0.010, 0.125>;
vector foodBarSize = <0.500, 0.010, 0.125>;
vector bathroomBarSize = <0.500, 0.010, 0.125>;
vector hygieneBarSize = <0.500, 0.010, 0.125>;
float standardWidth = 0.500;
float currentWidth;

///functions
float decayProcess(float need, float decay) {
    if (need > 0 && need <= 100) {
      need -= decay;
    } else if (need > 100) {
        need = 100;
    } else {
        need = 0;
    }
    return need;
  }

string displayUpdate(float standardWidth, float need, integer bar, string needName) {
    float currentWidth = standardWidth * (need / 100);
    llSetLinkPrimitiveParamsFast(bar, [
        PRIM_SIZE, <currentWidth, 0.010, 0.125>
    ]);
    return needName + (string)llFloor(need) + "\n";
}


default
{
    state_entry()
    {
        llSetTimerEvent(60);  ///updates every minute
        dialogChannel = -1 - (integer)("0x" + llGetSubString( (string)llGetKey(), -7, -1) ); ///determine a semi-randomized negative channel for dialog
    }

    timer()
    {
        sleep = decayProcess(sleep, sleepDecay);
        food = decayProcess(food, foodDecay);
        bathroom = decayProcess(bathroom, bladderDecay);
        hygiene = decayProcess(hygiene, hygieneDecay);
        string sleepText = displayUpdate(standardWidth, sleep, sleepBarLink, "Sleep: ");
        string foodText = displayUpdate(standardWidth, food, foodBarLink, "Food: ");
        string bathroomText = displayUpdate(standardWidth, bathroom, bathroomBarLink, "Bathroom: ");
        string hygieneText = displayUpdate(standardWidth, hygiene, hygieneBarLink, "Hygiene: ");
        llSetText(sleepText + foodText + bathroomText + hygieneText, white, 0);
    }
    touch_start(integer num_detected)
    {
        toucher = llDetectedKey(0);
        llDialog(toucher, dialogInitial, needsList, dialogChannel);
        llListenRemove(listenHandle);
        listenHandle = llListen(dialogChannel, "", toucher, "");
    }
    listen(integer channel, string name, key id, string message) {
        if(message == "Sleep") {
            llDialog(toucher, dialogFollowup, sleepResponses, dialogChannel);
        } else if(message == "Sleep+") {
            sleep += 33.3333;
        } else if(message == "Sleep++"){
            sleep += 66.6666;
        } else if(message == "Sleep+++") {
            sleep = 100;
        } else if(message == "Food") {
            llDialog(toucher, dialogFollowup, foodResponses, dialogChannel);
        } else if(message == "Food+") {
            food += 33.3333;
            bathroom -= 11.1111;
        } else if(message == "Food++") {
            food += 66.6666;
            bathroom -= 22.2222;
        } else if(message == "Food+++") {
            food = 100;
            bathroom -= 33.3333;
        } else if(message == "Bathroom") {
            llDialog(toucher, dialogFollowup, bathroomResponses, dialogChannel);
        } else if(message == "Bathroom+++") {
            bathroom = 100;
            hygiene -= 33.3333;
        } else if(message == "Hygiene") {
            llDialog(toucher, dialogFollowup, hygieneResponses, dialogChannel);
        } else if(message == "Hygiene+") {
            hygiene += 33.3333;
        } else if(message == "Hygiene++") {
            hygiene += 66.6666;
        } else if(message == "Hygiene+++") {
            hygiene = 100;
        }
    }
}