
// To calculate the reading time of a content, we can use the following function.
// The function takes a string content and returns an integer value of the reading time.
// The reading time is calculated by dividing the number of words in the content by the average reading speed of a person.

int calculateReadingTime(String content){
  // average reading speed of a person is 200 words per minute
  int words = content.split(RegExp(r'\s+')).length;

  // speed = d/t => t = d/s
  // human reading time is 200 words per minute
  int readingTime = (words/200).ceil();

  return readingTime;
  
}