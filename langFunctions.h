#include <stdlib.h>
#include <stdio.h>
#include <string.h>

struct IdentifierStructure
{
    char*  id;
    float  value;
}identifiers[20];

int numIdentifier = 0;




void storeIdentifier(char* identifier, char* valueString){

    int value = -1;

    if(strcmp("False",valueString) == 0){
        value = 0;
    }

    if(strcmp("True",valueString) == 0){
        value = 1;
    }

    identifiers[numIdentifier].value = value;
    identifiers[numIdentifier].id = identifier;
    numIdentifier++;

}

int searchIdentifier(char* identifier){

    for(int i = 0;i<numIdentifier;i++){
        if(strcmp(identifiers[i].id,identifier) == 0){
            return i;
        }
    }
    return -1;
}


float searchValue(int value){

    if(value >= 0){
        return identifiers[value].value;
    }
    else{
        return 0;
    }
    
}

float checkConditional(float val1,float val2){

    if(val1 == 1 && val2 == 1){
        return 1;
    }
    if(val1 == 1 && val2 == 0){
        return 0;
    }
    if(val1 == 0 && val2 == 1){
        return 1;
    }
    if(val1 == 0 && val2 == 0){
        return 1;
    }

    return 0;

}

void printResult(float value){

    if(value == 1){
        printf("\tResult: %s\n","True");
    }else{
        printf("\tResult: %s\n","False");
    }

}

float checkBiconditional(float val1,float val2){

    if(val1 == val2){
        return 1;
    }

    return 0;
}
