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
    it 'abc skip 2', ->
      text = 'abc'
      expect(UnicodeSpliter.splitChar(text, false, 2)).toEqual [
        {index: 0, value: 'ab'},
        {index: 2, value: 'c'},
      ]
  describe 'UnicodeSpliter.splitChar with Strict', ->
    it 'ab', ->
      text = 'ab'
      expect(UnicodeSpliter.splitChar(text, true)).toEqual [
        {index: 0, value: 'a'},
        {index: 1, value: 'b'},
      ]
    it 'あい', ->
      text = 'あい'
      expect(UnicodeSpliter.splitChar(text, true)).toEqual [
        {index: 0, value: 'あ'},
        {index: 1, value: 'い'},
      ]
    it 'a𠮷b Surrogate', ->
      text = 'a𠮷b'
      expect(UnicodeSpliter.splitChar(text, true)).toEqual [
        {index: 0, value: 'a'},
        {index: 1, value: '𠮷'},
        {index: 3, value: 'b'},
      ]
    it 'a🐱b Surrogate', ->
      text = 'a🐱b'
      expect(UnicodeSpliter.splitChar(text, true)).toEqual [
        {index: 0, value: 'a'},
        {index: 1, value: '🐱'},
        {index: 3, value: 'b'},
      ]
    it 'aか\u3099b Surrogate', ->
      text = 'aか\u3099b' # 'が'
      expect(UnicodeSpliter.splitChar(text, true)).toEqual [
        {index: 0, value: 'a'},
        {index: 1, value: 'か\u3099'},
        {index: 3, value: 'b'},
      ]
    it 'abc skip 2', ->
      text = 'abc'
      expect(UnicodeSpliter.splitChar(text, true, 2)).toEqual [
        {index: 0, value: 'ab'},
        {index: 2, value: 'c'},
      ]
