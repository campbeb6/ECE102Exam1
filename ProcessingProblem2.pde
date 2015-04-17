void setup() {
  size(400, 300);
  background(0, 0, 150);
  float[] donations = doStuff();
  buildGraph(donations);
}

void buildGraph(float[] donations){
  int numBars = 16;
  int numDonations = donations.length;
  float[] random = new float[numBars];
  //drawing graph
  for (int i = 0; i < numBars; i++){
    random[i] = donations[int(random(0,numDonations-1))];
  }
  random = sort(random);
  int[] barsX = new int[numBars];
  int[] barsY = new int[numBars];
  int barWidth = int((395-numBars)/numBars);
 
  //calculate x position of each bar
  for(int i = 1; i <= numBars; i++){
    barsX[i-1] = i + barWidth*(i-1); 
  }
 
  //calculate height of each bar
  for(int i = 0; i < numBars; i++){
     barsY[i] = int(random[i] / 7);
  }  
  
  //draw that graph dawg
  for(int i = 0; i < numBars; i++){
    fill(255); 
    rect(barsX[i], 300, barWidth, -barsY[i]); 
  }
}
  
  





 float[] doStuff(){
  int numDonations = 100;
  float[] donations = new float[numDonations];
  float[] sorted = new float[numDonations];
  float[] topTen = new float[10];
  float[] stDevArray = new float[numDonations];
  
  //create random array of donations
  for (int i = 0; i < numDonations; i++){
    donations[i] = random(500, 2000);
  }
   
  sorted = sort(donations);
  //create array for top ten donations
  for (int i = 0; i < 10; i++){
    topTen[i] = sorted[numDonations-11+i];
  }
  
  float tenSum = 0;
  float bigSum = 0;
  
  //get total Average
  for (int i = 0; i < numDonations; i++){
    bigSum += sorted[i];
  }
  float bigAvg = bigSum/numDonations;
  println("Total Donations Average: " + bigAvg);
 
  //get top ten average
  for(int i = 0; i < 10; i++){
    tenSum += topTen[i];
  }
  float tenAvg = tenSum/10;
  println("Top Ten Average: " + tenAvg);
 
  //get standard deviation
  for (int i = 0; i < numDonations; i++){
     stDevArray[i] = pow((donations[i]-bigAvg),2);
  }
  float stDevSum = 0;
  float stDevAvg = 0;
  float stDev = 0;
  for (int i = 0; i < numDonations; i++){
    stDevSum += stDevArray[i];
  }
  stDevAvg = stDevSum/numDonations;
  stDev = sqrt(stDevAvg);
  println("Standard Deviation: " + stDev);
  
  //Get number of donations between 6 and 7 hundred dollars
  int countSixSeven = 0;
  for (int i = 0; i < numDonations; i++){
    if(donations[i] >= 600 && donations[i] <= 700){
      countSixSeven++;
    }
  }
  println("Number of donations between 6 and 7 hundred dollars: " + countSixSeven);
  return donations;
}
