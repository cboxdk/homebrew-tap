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
      url "https://github.com/cboxdk/telemetryd/releases/download/v0.46.0/telemetryd-0.46.0-aarch64-apple-darwin.tar.gz"
      sha256 "b0ccd9d66f10d3c9ec08ab380f66a56a3015198ac46222688dded88a90b6c8f2"
    end
    on_intel do
      url "https://github.com/cboxdk/telemetryd/releases/download/v0.46.0/telemetryd-0.46.0-x86_64-apple-darwin.tar.gz"
      sha256 "03c349633bc4aa876667277226f656fe5c0dae04d900f3559142b3a5033a8b1c"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/cboxdk/telemetryd/releases/download/v0.46.0/telemetryd-0.46.0-aarch64-unknown-linux-musl.tar.gz"
      sha256 "084fa86168341bbb8dce520eca7f31c4f821af7d2401602a5d1bfea3bef6af78"
    end
    on_intel do
      url "https://github.com/cboxdk/telemetryd/releases/download/v0.46.0/telemetryd-0.46.0-x86_64-unknown-linux-musl.tar.gz"
      sha256 "bcf416bb05bc7e586efbe668feadd3b8c2d6da8c110354fe1620f6625a5290a5"
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
