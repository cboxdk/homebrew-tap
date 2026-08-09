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
      url "https://github.com/cboxdk/telemetryd/releases/download/v0.18.0/telemetryd-0.18.0-aarch64-apple-darwin.tar.gz"
      sha256 "5328ce4d907d622a34315c63297c39e20e7a4caf1cc8997899c384f67a73e14e"
    end
    on_intel do
      url "https://github.com/cboxdk/telemetryd/releases/download/v0.18.0/telemetryd-0.18.0-x86_64-apple-darwin.tar.gz"
      sha256 "8d7c00e32f344bddc42ab2bf93b22b2a2974594b4a8e8044392735921c1155bd"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/cboxdk/telemetryd/releases/download/v0.18.0/telemetryd-0.18.0-aarch64-unknown-linux-musl.tar.gz"
      sha256 "dfae266ba2f56b8d4bd795b7e5dc2f2a13715b3c1db20bb8b7343830e186c663"
    end
    on_intel do
      url "https://github.com/cboxdk/telemetryd/releases/download/v0.18.0/telemetryd-0.18.0-x86_64-unknown-linux-musl.tar.gz"
      sha256 "47c494c9ff25bddec1a442856e275ce57c31d1c26f153d7dc80070d992217406"
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
