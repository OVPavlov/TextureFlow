This lib is made to simplify making post processing pipelines using dataflow paradigm

Example
---
The following code implements outline effect with downsampled glow:

```csharp
var x = Graph.Use(camera.targetTexture);
var outline = Graph.Process(outlineShader, x, new Vec("_PixelSize", 1, 1, true));

var glow = Graph.Downsample(x)
	.Proces(blurShader, new Vec("_PixelSize", 1, 0, true))
	.Proces(blurShader, new Vec("_PixelSize", 0, 1, true));

commandBuffer = Graph.Process(composeShader, x,
	outline.As("_OutlineTex"),
	glow.As("_GlowTex"),
	new Float("_Intensity", intensity),
	new Col("_Color", color))
	.ToCommandBuffer();
```

