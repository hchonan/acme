.PHONY: all test lint vet fmt build clean

GO          = go
GO_BUILD    = $(GO) build
GO_FORMAT   = $(GO) fmt
GO_LIST     = $(GO) list
GO_LINT     = golint
GO_TEST     = $(GO) test
GO_VET      = $(GO) vet
GO_LDFLAGS  = -ldflags "-X main.buildHash=$(BUILD_HASH) -X main.version=$(VERSION)"

#EXECUTABLES = dst/bin/wild-le dst/bin/dns dst/bin/dns-lego
EXECUTABLES = dst/bin/wild-le dst/bin/dns
TARGETS     = $(EXECUTABLES)
GO_PKGROOT  = ./...

verSION     = 0.0.1
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
	-rm -rf ./dst

dst/bin/wild-le: cmd/wild-le
	$(GO_BUILD) -o $@ $(GO_LDFLAGS) ./$?

#dst/bin/dns-lego: cmd/dns-lego
#	$(GO_BUILD) -o $@ $(GO_LDFLAGS) ./$?

dst/bin/dns: cmd/dns
	$(GO_BUILD) -o $@ $(GO_LDFLAGS) ./$?

