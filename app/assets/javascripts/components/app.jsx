class Post extends React.Component {
  constructor(props) {
    super(props);

    this.state = {
      feedback: 'Loading...'
    };
  }
  componentDidMount() 
  {
      this.setState({feedback: this.props.feed}, function () 
      {
          console.log(this.state.feedback);
      });   
  }
  render() {
    return(
        <div>
            <div className="card-images">
                <img src={this.props.image} alt={this.props.title} id="ad-image"/>
                <div className="container-images">
                    <h4><b>{this.props.title}</b></h4> 
                    <p>{this.state.feedback}</p> 
                    <p>Rating: {this.props.rating}/10</p>
                </div>
            </div>
        </div>
        )   
  }
}



/*

      var that = this;
      fetch("//api.giphy.com/v1/gifs/search?q=$" + that.props.title + "&api_key=dc6zaTOxFJmzC")
        .then(function(response) {
          return response.json()
        }).then(function(json) {
              // console.log('parsed json', json.data[0].images.fixed_height.url)
               that.setState({feedback: json.data[0].images.fixed_height.url}, function () 
               {
                  console.log(that.state.feedback);
                });
        }).catch(function(ex) {
          console.log('parsing failed', ex)
        })
        
  */