UnicodeSpliter = require '../lib/unicode-spliter'

describe 'UnicodeSpliter', ->
  describe 'UnicodeSpliter.splitChar', ->
    it 'ab', ->
      text = 'ab'
      expect(UnicodeSpliter.splitChar(text)).toEqual [
        {index: 0, value: 'a'},
        {index: 1, value: 'b'},
      ]
    it 'あい', ->
      text = 'あい'
      expect(UnicodeSpliter.splitChar(text)).toEqual [
        {index: 0, value: 'あ'},
        {index: 1, value: 'い'},
      ]
    it 'a𠮷b Surrogate', ->
      text = 'a𠮷b'
      expect(UnicodeSpliter.splitChar(text)).toEqual [
        {index: 0, value: 'a'},
        {index: 1, value: '𠮷'},
        {index: 3, value: 'b'},
      ]
    it 'a🐱b Surrogate', ->
      text = 'a🐱b'
      expect(UnicodeSpliter.splitChar(text)).toEqual [
        {index: 0, value: 'a'},
        {index: 1, value: '🐱'},
        {index: 3, value: 'b'},
      ]
