using UnityEngine;

namespace TextureFlow
{
    static class MeshCreator
    {
        public static Mesh Quad
        {
            get
            {
                if (!_quad)
                    _quad = GetQuad(new Color(0, 0, 0, 0));
                return _quad;
            }
        }
        private static Mesh _quad;

        public static Mesh GetQuad(Color color)
        {
            //0 - 1
            //| \ |
            //2 - 3
            return new Mesh
            {
                vertices = new Vector3[]
                {
                    new Vector3(0,0),
                    new Vector3(0,1),
                    new Vector3(1,0),
                    new Vector3(1,1),
                },
                uv = new Vector2[]
                {
                    new Vector2(0,0),
                    new Vector2(0,1),
                    new Vector2(1,0),
                    new Vector2(1,1),
                },
                colors = new Color[]
                {
                    color, color, color, color,
                },
                triangles = new int[]
                {
                    0,1,3,
                    3,2,0,
                },
            };
        }

    }

}