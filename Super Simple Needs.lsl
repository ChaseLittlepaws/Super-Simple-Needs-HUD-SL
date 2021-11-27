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
list needsList = ["Sleep", "Food", "Bathroom", "Hygiene"];
list sleepResponses = ["Sleep+", "Sleep++", "Sleep+++"];
list foodResponses = ["Food+", "Food++", "Food+++"];
list bathroomResponses = ["Bathroom+++"];
list hygieneResponses = ["Hygiene+", "Hygiene++", "Hygiene+++"];
key toucher;
integer dialogChannel;
integer listenHandle;

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

string needsText(string needName, float need) {
    return needName + (string)llFloor(need) + "\n";
}

default
{
    state_entry()
    {
        llSetTimerEvent(1);  ///updates every second for testing purposes
        dialogChannel = -1 - (integer)("0x" + llGetSubString( (string)llGetKey(), -7, -1) ); ///determine a semi-randomized negative channel for dialog
        llSetText("Sleep: 100\nFood: 100\nBladder: 100\nHygiene: 100", white, opaque);
    }

    timer()
    {
        list region = llGetAgentList(AGENT_LIST_REGION,[]);
        key owner = llGetOwner();
        if(llListFindList(region, [owner]) != -1){ ///owner in region
            sleep = decayProcess(sleep, sleepDecay);
            string sleepText = needsText("Sleep: ", sleep);
            food = decayProcess(food, foodDecay);
            string foodText = needsText("Food: ", food);
            bathroom = decayProcess(bathroom, bladderDecay);
            string bathroomText = needsText("Bathroom: ", bathroom);
            hygiene = decayProcess(hygiene, hygieneDecay);
            string hygieneText = needsText("Hygiene: ", hygiene);
            llSetText(sleepText + foodText + bathroomText + hygieneText, white, opaque);
        }
    }
    touch_start(integer num_detected)
    {
        toucher = llDetectedKey(0);
        llDialog(toucher, dialogInitial, needsList, dialogChannel);
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
            hygiene -= 22.2222;
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