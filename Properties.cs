using UnityEngine;

namespace TextureFlow
{
    public abstract class Property
    {
        internal abstract void Apply(Graph graph);

        public static implicit operator Property(RenderTexture texture)
        {
            return new Input(texture);
        }
    }

    public class Input : Property
    {
        string _property;
        Graph _graph;

        public Input(string property, Graph graph)
        {
            _property = property;
            _graph = graph;
        }
        public Input(Graph graph) : this("_MainTex", graph) { }
        public Input(string property, RenderTexture texture)
        {
            _property = property;
            _graph = (Graph)texture;
        }
        public Input(RenderTexture texture) : this("_MainTex", texture) { }

        public static implicit operator Input(RenderTexture texture)
        {
            return new Input(texture);
        }


        internal override void Apply(Graph graph)
        {
            graph._inputs.Add(_property, _graph);
        }

    }

    public class Vec : Property
    {
        string _property;
        Vector4 _vector;
        bool _relativeToResolution;

        public Vec(string property, Vector4 vector, bool relativeToResolution = false)
        {
            _property = property;
            _vector = vector;
            _relativeToResolution = relativeToResolution;
        }
        public Vec(string property, Vector3 vector, bool relativeToResolution = false) : this(property, (Vector4)vector, relativeToResolution) { }
        public Vec(string property, Vector2 vector, bool relativeToResolution = false) : this(property, (Vector4)vector, relativeToResolution) { }
        public Vec(string property, float x, float y, float z, float w, bool relativeToResolution = false) : this(property, new Vector4(x, y, z, w), relativeToResolution) { }
        public Vec(string property, float x, float y, float z, bool relativeToResolution = false) : this(property, x, y, z, 0, relativeToResolution) { }
        public Vec(string property, float x, float y, bool relativeToResolution = false) : this(property, x, y, 0, 0, relativeToResolution) { }
        public Vec(string property, float x, bool relativeToResolution = false) : this(property, x, 0, 0, 0, relativeToResolution) { }

        internal override void Apply(Graph graph)
        {
            if (_relativeToResolution)
            {
                Vector2Int size = GetRes(graph);
                float pixX = 1f / size.x;
                float pixY = 1f / size.y;
                graph._propertyBlock.SetVector(_property, new Vector4(_vector.x * pixX, _vector.y * pixY, _vector.z * pixX, _vector.w * pixY));
            }
            else
                graph._propertyBlock.SetVector(_property, _vector);
        }

        private Vector2Int GetRes(Graph graph)
        {
            if (graph._createTexture != null)
            {
                return new Vector2Int(graph._createTexture.Value.width, graph._createTexture.Value.height);
            }
            if (graph._textureReference != null)
            {
                return new Vector2Int(graph._textureReference.width, graph._textureReference.height);
            }

            if (graph._inputs.Count == 0) throw new System.Exception("there's no inputs in the node and it doesn't create a texture");

            Vector2Int size = Vector2Int.zero;
            foreach (var pair in graph._inputs)
            {
                size = GetRes(pair.Value);
                size.x = size.x / graph._downsample;
                size.y = size.y / graph._downsample;
                break;
            }
            return size;
        }

    }

    public class Col : Property
    {
        string _property;
        Color _color;

        public Col(string property, Color color)
        {
            _property = property;
            _color = color;
        }
        public Col(string property, float r, float g, float b, float a) : this(property, new Color(r,  g,  b,  a)) { }

        internal override void Apply(Graph graph)
        {
            graph._propertyBlock.SetColor(_property, _color);
        }
    }

    public class Float : Property
    {
        string _property;
        float _value;
        public Float(string property, float value)
        {
            _property = property;
            _value = value;
        }
        internal override void Apply(Graph graph)
        {
            graph._propertyBlock.SetFloat(_property, _value);
        }
    }

    public class Downsample : Property
    {
        int _value;
        public Downsample(int value)
        {
            if (value < 2) throw new System.ArgumentOutOfRangeException();
            _value = value;
        }
        internal override void Apply(Graph graph)
        {
            graph._downsample = _value;
        }
    }

    public class SetMesh : Property
    {
        Mesh _value;
        public SetMesh(Mesh value)
        {
            _value = value;
        }
        internal override void Apply(Graph graph)
        {
            graph._mesh = _value;
        }
    }
}