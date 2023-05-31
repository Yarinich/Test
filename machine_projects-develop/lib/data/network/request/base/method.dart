enum Method {
  get('GET'),
  post('POST'),
  put('PUT'),
  delete('DELETE'),
  head('HEAD'),
  patch('PATCH');

  const Method(this.name);

  final String name;
}
