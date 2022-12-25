package main

import (
	"log"
	"net/http"
	"net/http/httputil"
	"net/url"
)

var (
	hostProxy map[string]*httputil.ReverseProxy = map[string]*httputil.ReverseProxy{}
)

type baseHandle struct{
	Config *Config
}

func ProxyHTTP(c *Config) {
	h := &baseHandle{Config: c}
	http.Handle("/", h)

	server := &http.Server{
		Addr:    ":80",
		Handler: h,
	}
	log.Fatal(server.ListenAndServe())
}


func (h *baseHandle) ServeHTTP(w http.ResponseWriter, r *http.Request) {
	host := r.Host

	if fn, ok := hostProxy[host]; ok {
		fn.ServeHTTP(w, r)
		return
	}

	backend, _ := h.Config.Match(host)
	if backend != "" {
		log.Printf("routing \"%s\" to \"http://%s:80\"\n", host, backend)

		remoteUrl, err := url.Parse("http://" + backend + ":80")
		if err != nil {
			log.Println("target parse fail:", err)
			return
		}

		proxy := httputil.NewSingleHostReverseProxy(remoteUrl)
		hostProxy[host] = proxy
		proxy.ServeHTTP(w, r)
		return
	}
	// TODO: Should probably handle this differently?
	w.Write([]byte("403: Host forbidden " + host))
}
