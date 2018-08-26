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

        public Vec(string property, Vector4 vector)
        {
            _property = property;
            _vector = vector;
        }
        public Vec(string property, Vector3 vector) : this(property, (Vector4)vector) { }
        public Vec(string property, Vector2 vector) : this(property, (Vector4)vector) { }
        public Vec(string property, float x, float y, float z, float w) : this(property, new Vector4(x, y, z, w)) { }
        public Vec(string property, float x, float y, float z) : this(property, x, y, z, 0) { }
        public Vec(string property, float x, float y) : this(property, x, y, 0, 0) { }
        public Vec(string property, float x) : this(property, x, 0, 0, 0) { }

        internal override void Apply(Graph graph)
        {
            graph._propertyBlock.SetVector(_property, _vector);
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