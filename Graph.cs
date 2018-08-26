using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Rendering;

namespace TextureFlow
{
    public class Graph
    {
        internal Shader _shader;
        internal int _pass;
        internal MaterialPropertyBlock _propertyBlock = new MaterialPropertyBlock();
        internal Dictionary<string, Graph> _inputs = new Dictionary<string, Graph>();
        internal int _downsample = 1;
        internal Mesh _mesh;
        private RenderTextureDescriptor? _createTexture = null;
        private RenderTexture _textureReference;
        private int _outputReferences = 0;
        private RenderTexture _output;


        #region Operations
        public static Graph Downsample(Graph graph, PowOf2 pot = PowOf2._2)
        {
            Shader downsampling16 = Shader.Find("Hidden/TextureFlow/Downsampling16X");
            Graph newGraph;
            int di = (int)pot;
            for (; di > 2; di >>= 2)
            {
                newGraph = new Graph()
                {
                    _shader = downsampling16,
                    _downsample = 4,
                };
                ((Property)graph).Apply(newGraph);
                graph = newGraph;
            }

            if (di == 2)
            {
                newGraph = new Graph()
                {
                    _downsample = 2,
                };
                ((Property)graph).Apply(newGraph);
                graph = newGraph;
            }

            return graph;
        }

        public static Graph Create(int width,int height)
        {
            return Create(new RenderTextureDescriptor(width, height));
        }
        public static Graph Create(RenderTextureDescriptor descriptor)
        {
            return new Graph()
            {
                _createTexture = descriptor
            };
        }

        public static Graph Use(RenderTexture texture)
        {
            return new Graph()
            {
                _textureReference = texture
            };
        }

        public static Graph Process(Shader shader, int pass, params Property[] properties)
        {
            Graph graph = new Graph()
            {
                _shader = shader,
                _pass = pass,
            };

            for (int i = 0; i < properties.Length; i++)
                properties[i].Apply(graph);

            return graph;
        }

        public static Graph Clear(Graph graph, bool color, bool depth, bool stencil)
        {
            int pass = 0;
            pass += color ? 1 : 0;
            pass += depth ? 2 : 0;
            pass += stencil ? 4 : 0;

            Graph newGraph = new Graph()
            {
                _shader = Shader.Find("Hidden/InternalClear"),
                _pass = pass,
            };
            ((Property)graph).Apply(newGraph);


            return newGraph;
        }
        #endregion

        #region GraphAnalysis
        private void FillQueue(List<Graph> queue)
        {
            ++_outputReferences;
            if (_outputReferences > 1)
                return;

            foreach (var pair in _inputs)
                pair.Value.FillQueue(queue);

            queue.Add(this);
        }

        private static void FillTextures(List<Graph> queue, TexturePool pool)
        {
            for (int i = 0; i < queue.Count; i++)
            {
                Graph graph = queue[i];
                if (graph._createTexture != null)
                {
                    graph._output = new RenderTexture(graph._createTexture.Value);
                    continue;
                }
                if (graph._textureReference != null)
                {
                    graph._output = graph._textureReference;
                    continue;
                }

                if (graph._inputs.Count < 1) throw new System.Exception("there's no inputs in the node and it doesn't create a texture");

                int width = 0, height = 0;
                foreach (var pair in graph._inputs)
                {
                    width = pair.Value._output.width / graph._downsample;
                    height = pair.Value._output.height / graph._downsample;
                    break;
                }

                graph._output = pool.GetOrAdd(width, height);

                foreach (var pair in graph._inputs)
                {
                    graph._propertyBlock.SetTexture(pair.Key, pair.Value._output);
                    pair.Value._outputReferences--;
                    if (pair.Value._outputReferences == 0)
                        pool.Release(pair.Value._output);
                }
            }
        }

        private static void BuildCommandBuffer(List<Graph> queue, CommandBuffer cb)
        {
            RenderTexture previousTarget = null;
            for (int i = 0; i < queue.Count; i++)
            {
                Graph graph = queue[i];

                if (graph._createTexture != null || graph._textureReference != null)
                    continue;

                if (previousTarget != graph._output)                
                    cb.SetRenderTarget(previousTarget = graph._output);                
                Shader shader = graph._shader != null ? graph._shader : Shader.Find("Hidden/BlitCopy");
                Mesh mesh = graph._mesh != null ? graph._mesh : MeshCreator.Quad;
                cb.DrawMesh(mesh, Matrix4x4.identity, new Material(shader), 0, graph._pass, graph._propertyBlock);
            }
        }

        public CommandBuffer ToCommandBuffer()
        {
            List<Graph> queue = new List<Graph>();
            FillQueue(queue);
            FillTextures(queue, new TexturePool());
            CommandBuffer cb = new CommandBuffer();
            cb.SetViewProjectionMatrices(Matrix4x4.identity, Matrix4x4.Ortho(0, 1, 0, 1, 0, 1));
            BuildCommandBuffer(queue, cb);
            return cb;
        }
        #endregion

        #region SyntacticSugar
        public static implicit operator Property(Graph graph)
        {
            return new Input(graph);
        }
        public static implicit operator Graph(RenderTexture texture)
        {
            return new Graph()
            {
                _textureReference = texture
            };
        }

        public Property As(string property)
        {
            return new Input(property, this);
        }

        public Graph Proces(Shader shader, int path, params Property[] properties)
        {
            System.Array.Resize(ref properties, properties.Length + 1);
            properties[properties.Length - 1] = this;

            return Graph.Process(shader, path, properties);
        }

        public Graph Downsample(PowOf2 pot = PowOf2._2)
        {
            return Graph.Downsample(this, pot);
        }

        public Graph Clear(bool color, bool depth, bool stencil)
        {
            return Graph.Clear(this, color, depth, stencil);
        }
        #endregion
    }

    public enum PowOf2
    {
        _2 = 2,
        _4 = 4,
        _8 = 8,
        _16 = 16,
        _32 = 32,
        _64 = 64,
        _128 = 128,
        _256 = 256,
        _512 = 512,
        _1024 = 1024,
        _2048 = 2048,
        _4096 = 4096,
        _8192 = 8192,
        _16384 = 16384,
    }
}
