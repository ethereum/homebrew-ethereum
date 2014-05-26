require 'formula'

class Jsonrpc < Formula

  version '0.2.1'

  homepage 'https://github.com/cinemast/libjson-rpc-cpp'
  url 'https://github.com/cinemast/libjson-rpc-cpp.git', :branch => 'master'

  depends_on 'cmake' => :build
  depends_on 'curl'

  option "allow-origin", "Patch to add Access-Control-Allow-Origin: * in headers"

  def install
    system "cd", "build"
    system "cmake", "."
    system "make"
    lib.install Dir['out/*.dylib']
  end

  def patches
    DATA if build.include? "allow-origin"
  end

end
__END__
diff --git a/src/jsonrpc/connectors/httpserver.cpp b/src/jsonrpc/connectors/httpserver.cpp
index 7e9c08f..4da94d1 100644
--- a/src/jsonrpc/connectors/httpserver.cpp
+++ b/src/jsonrpc/connectors/httpserver.cpp
@@ -133,7 +133,9 @@ namespace jsonrpc
     {
         struct mg_connection* conn = (struct mg_connection*) addInfo;
         if (mg_printf(conn, "HTTP/1.1 200 OK\r\n"
-                      "Content-Type: application/json\r\n"
+                      "Access-Control-Allow-Origin: *\r\n"
+                      "Access-Control-Allow-Headers: Content-Type\r\n"
+                      "Content-Type: application/json; charset=utf-8\r\n"
                       "Content-Length: %d\r\n"
                       "\r\n"
                       "%s",(int)response.length(), response.c_str()) > 0)
