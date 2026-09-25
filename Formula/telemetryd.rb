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
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/cboxdk/telemetryd/releases/download/v0.55.2/telemetryd-0.55.2-aarch64-apple-darwin.tar.gz"
      sha256 "9b92aec77619b706565482ac542eb88cd4c55acf2a5099416bb5cd885dfc5b0e"
    end
    on_intel do
      url "https://github.com/cboxdk/telemetryd/releases/download/v0.55.2/telemetryd-0.55.2-x86_64-apple-darwin.tar.gz"
      sha256 "119c18ba203bdc02386ea6cb43979690bffcd46c67d4c76fb6e3466997da802b"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/cboxdk/telemetryd/releases/download/v0.55.2/telemetryd-0.55.2-aarch64-unknown-linux-musl.tar.gz"
      sha256 "542b73dc85cda705ffdf2a001ba80c3d1eedbf66458eafb08e26693bbdfddcef"
    end
    on_intel do
      url "https://github.com/cboxdk/telemetryd/releases/download/v0.55.2/telemetryd-0.55.2-x86_64-unknown-linux-musl.tar.gz"
      sha256 "dbb37e9152d816e281e8ded4265267aea991b93ce356fae61b286286f74c4cb8"
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
