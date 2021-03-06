describe "Iterating", ->
  describe "with observable arrays", ->
    template = makeTemplate """
      ul
        - @items.forEach (item) ->
          li= item.name
    """

    it "should have an item for each element", ->
      model =
        items: Observable [
          {name: "Hello"}
          {name: "Test"}
        ]

      element = template(model)

      assert.equal all("li", element).length, 2
      assert.equal all("li", element)[0].textContent, "Hello"

    it "should add items when items are added to the array", ->
      model =
        items: Observable [
          {name: "Hello"}
          {name: "Test"}
        ]

      element = template(model)
      assert.equal all("li", element).length, 2

      model.items.push name: "yolo"
      assert.equal all("li", element).length, 3

    it "should remove items when they are removed", ->
      model =
        items: Observable [
          {name: "Hello"}
          {name: "Test"}
        ]

      element = template(model)
      assert.equal all("li", element).length, 2

      model.items.pop()
      model.items.pop()
      assert.equal all("li", element).length, 0

      model.items.push name: "wat"
      assert.equal all("li", element).length, 1

  describe "with regular arrays", ->
    template = makeTemplate """
      ul
        - @items.forEach (item) ->
          li= item.name
    """
    it "should have an item for each element", ->
      model =
        items: [
          {name: "Hello"}
          {name: "Test"}
        ]

      element = template(model)

      assert.equal all("li", element).length, 2
      assert.equal all("li", element)[0].textContent, "Hello"

    it "will not add items when items are added to the array", ->
      model =
        items: [
          {name: "Hello"}
          {name: "Test"}
        ]

      element = template(model)
      assert.equal all("li", element).length, 2
      model.items.push name: "yolo"
      assert.equal all("li", element).length, 2

    it "will not remove items when they are removed", ->
      model =
        items: [
          {name: "Hello"}
          {name: "Test"}
        ]

      element = template(model)
      assert.equal all("li", element).length, 2
      model.items.pop()
      model.items.pop()
      assert.equal all("li", element).length, 2

  it "should render inline maps", ->
    template = makeTemplate """
      ul
        = @items.map(@itemView)
    """

    model =
      items: [
        "Hello"
        "there"
        "stranger"
      ]
      itemView: makeTemplate """
        li= this
      """

    element = template(model)
    assert.equal all("li", element).length, 3
