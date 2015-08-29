use OO::Monitors;

monitor CapturingOutput {
  has Supply $.supply .= new;

  method print(*@str) {
    $.supply.emit($_) for @str;
  }

  method flush { }
}
