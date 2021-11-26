float sleep = 100;
float food = 100;
float bladder = 100;
float hygiene = 100;
float sleepDecay = 0.1042;
float foodDecay = 0.208;
float bladderDecay = 0.2777;
float hygieneDecay = 0.0694;
vector white = <1.0, 1.0, 1.0>;
float opaque = 1.0;

float decayProcess(float need, float decay) {
    if (need > 0) {
      need -= decay;
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
            bladder = decayProcess(bladder, bladderDecay);
            string bladderText = needsText("Bladder: ", bladder);
            hygiene = decayProcess(hygiene, hygieneDecay);
            string hygieneText = needsText("Hygiene: ", hygiene);
            llSetText (sleepText + foodText + bladderText + hygieneText, white, opaque);
        }
    }
}