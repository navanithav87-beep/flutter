int sub(int a , int b){
  return a-b ;
}

void greet(String name){
  print('Hello $name');
}

void add(int b,int a){
  int c = b+a;
  print('$b + $a is $c');
}

void mul(int a, int b){
  print(a*b);
}

void div(int a, int b){
  double c = a/b;
  print(c);
}

double divide(int a , int b){
  return a/b;
}

void main(){
  greet('Navanitha');
  print(sub(11,5));
  add(8,9);
  mul(7,9);
  div(71,9);
  print(divide(7777,12));
}