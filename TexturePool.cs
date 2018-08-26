using System.Collections.Generic;
using UnityEngine;

namespace TextureFlow
{
    class TexturePool
    {
        Dictionary<uint, Queue<RenderTexture>> _textures = new Dictionary<uint, Queue<RenderTexture>>();

        public RenderTexture GetOrAdd(int width, int height)
        {
            uint hash = ToHash(width, height);
            Queue<RenderTexture> list;
            if (!_textures.TryGetValue(hash, out list))
                _textures.Add(hash, list = new Queue<RenderTexture>());

            if (list.Count > 0)
                return list.Dequeue();
            return new RenderTexture(width, height, 0);
        }


        public void Release(RenderTexture texture)
        {
            uint hash = ToHash(texture.width, texture.height);
            Queue<RenderTexture> list;
            if (!_textures.TryGetValue(hash, out list))
                _textures.Add(hash, list = new Queue<RenderTexture>());

            list.Enqueue(texture);
        }

        public void Add(RenderTexture texture)
        {
            uint hash = ToHash(texture.width, texture.height);
            Queue<RenderTexture> list;
            if (!_textures.TryGetValue(hash, out list))
                _textures.Add(hash, list = new Queue<RenderTexture>());

            list.Enqueue(texture);
        }

        private uint ToHash(int width, int height)
        {
            return ((uint)width) | ((uint)height) << 16;
        }
    }
}
