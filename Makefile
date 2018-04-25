.PHONY: all test lint vet fmt build clean

GO          = go
GO_BUILD    = $(GO) build
GO_FORMAT   = $(GO) fmt
GO_LIST     = $(GO) list
GO_LINT     = golint
GO_TEST     = $(GO) test
GO_VET      = $(GO) vet
GO_LDFLAGS  = -ldflags "-X main.buildHash=$(BUILD_HASH) -X main.version=$(VERSION)"

EXECUTABLES = dst/bin/wild-le dst/bin/dns
TARGETS     = $(EXECUTABLES)
GO_PKGROOT  = ./...

VERSION     = 0.0.1
BUILD_HASH  = $(shell git rev-parse HEAD)
GO_PACKAGES = $(shell $(GO_LIST) $(GO_PKGROOT) | grep -v vendor)

all: build

test:
	$(GO_TEST) $(GO_PACKAGES) -test.short
lint:
	$(GO_LINT) -set_exit_status $(GO_PACKAGES)
vet:
	$(GO_VET) $(GO_PACKAGES)
fmt:
	$(GO_FORMAT) $(GO_PKGROOT)

build: $(TARGETS)

clean:
	-rm -f ./dst/bin/wild-le
	-rm -f ./dst/bin/dns

dst/bin/wild-le: cmd/wild-le acme.go crypto.go
	$(GO_BUILD) -o $@ $(GO_LDFLAGS) ./cmd/wild-le

dst/bin/dns: cmd/dns acme.go crypto.go
	$(GO_BUILD) -o $@ $(GO_LDFLAGS) ./cmd/dns

