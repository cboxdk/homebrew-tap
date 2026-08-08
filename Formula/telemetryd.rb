# Homebrew formula for telemetryd.
#
# Lives here so it is versioned with the code it installs, which is what stops the
# formula describing a version that was never built.
#
# `scripts/publish-formula.py` fills in the checksums from a published release and
# pushes the result to cboxdk/homebrew-tap. The placeholders below are deliberate: a
# formula with real-looking checksums that nobody verified is worse than one that
# obviously is not ready.
class Telemetryd < Formula
  desc "Single-binary observability backend: OTLP in, Loki/Tempo/Prometheus APIs out"
  homepage "https://github.com/cboxdk/telemetryd"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/cboxdk/telemetryd/releases/download/v0.13.1/telemetryd-0.13.1-aarch64-apple-darwin.tar.gz"
      sha256 "1a939b6bb233efca70add3dc3afb0e2b7b19fc4f11eb9eb26f9df300ca36292b"
    end
    on_intel do
      url "https://github.com/cboxdk/telemetryd/releases/download/v0.13.1/telemetryd-0.13.1-x86_64-apple-darwin.tar.gz"
      sha256 "aabbe2be065ddb2226cb68a8989002ad49ec77c00dd5a9e58923e0e063bbdaa0"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/cboxdk/telemetryd/releases/download/v0.13.1/telemetryd-0.13.1-aarch64-unknown-linux-musl.tar.gz"
      sha256 "7ab1acd9b383fe8e0df966125c7e03c4b8b127308274c603bada2301d593aa6c"
    end
    on_intel do
      url "https://github.com/cboxdk/telemetryd/releases/download/v0.13.1/telemetryd-0.13.1-x86_64-unknown-linux-musl.tar.gz"
      sha256 "be7d2c9aca88ca3c883a8c090f797f3799b1a219c5f8ccb3bdf95eeef8dde00b"
    end
  end

  def install
    bin.install "telemetryd"
    doc.install "README.md", "COMPATIBILITY.md", "SECURITY.md"
    (etc/"telemetryd").install "telemetryd.toml.example"
  end

  service do
    run [opt_bin/"telemetryd", "serve"]
    keep_alive true
    working_dir var
    log_path var/"log/telemetryd.log"
    error_log_path var/"log/telemetryd.log"
  end

  test do
    # `version` proves the binary runs and reports its build target; `validate` proves
    # it can resolve a complete configuration from nothing, which is the product's
    # central claim.
    assert_match version.to_s, shell_output("#{bin}/telemetryd version")
    assert_match "Configuration is valid",
      shell_output("#{bin}/telemetryd validate --data-dir #{testpath}/data")
  end
end

# client-id probe
